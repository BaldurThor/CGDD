class_name AbilityPool extends Resource

## Passive abilities
@export var abilities: Array[AbilityInfo] = []
## Abilities that grant the player a weapon
@export var weapons: Array[AbilityInfo] = []
## Abilities that are only offered on killing a boss
@export var corrupted_abilities: Array[AbilityInfo] = []
## The weight of a common ability being chosen.
@export var rate_common: int = 0
## The weight of an uncommon ability being chosen.
@export var rate_uncommon: int = 0
## The weight of a rare ability being chosen.
@export var rate_rare: int = 0
## The levels at which the player is guaranteed to get a choice of weapons
@export var weapon_guarantee_breakpoints: Array[int] = []

var global_ability_pool: Array[AbilityInfo] = []
var global_weapon_pool: Array[AbilityInfo] = []
var global_corrupted_pool: Array[AbilityInfo] = []

var pick_counts: Dictionary = {}
var guarantees: Dictionary = {}

# Workaround for not having a _ready() function in the resource
var initialized: bool = false

func _pick_ability(ability_pool: Array[AbilityInfo]) -> AbilityInfo:
	var player: Player = GameManager.get_player()
	while ability_pool.size() > 0:
		var ability = ability_pool.pop_front()
		
		if ability.required_level > 0 and player.experience.current_level < ability.required_level:
			continue
		
		return ability
	
	return null

func _get_ability_pool() -> Array[AbilityInfo]:
	var ability_pool = global_ability_pool.duplicate()
	## Sort the array in ascending order based on ability rarity
	ability_pool.sort_custom(func(a, b): return int(a.rarity) < int(b.rarity))
	return ability_pool
	
func _get_weapon_pool() -> Array[AbilityInfo]:
	var weapon_pool = global_weapon_pool.duplicate()
	weapon_pool.shuffle()
	return weapon_pool
	
func _get_corrupted_pool() -> Array[AbilityInfo]:
	var corrupted_pool = corrupted_abilities.duplicate()
	corrupted_pool.shuffle()
	return corrupted_pool
	
func _create_ability_accumulator(pool: Array[AbilityInfo]) -> Array[int]:
	var total_weight: int = 0
	var accumulator: Array[int] = []
	for ability in pool:
		var this_weight: int = 0
		match ability.rarity:
			AbilityInfo.Rarity.COMMON:
				this_weight = rate_common
			AbilityInfo.Rarity.UNCOMMON:
				this_weight = rate_uncommon
			AbilityInfo.Rarity.RARE:
				this_weight = rate_rare
			_:
				print_debug("WARNING: An ability was found in loot_table that was of an invalid rarity. Ignoring...")
				continue
		total_weight += this_weight
		accumulator.append(total_weight)
	return accumulator

func _init_pool():
	global_ability_pool = abilities.duplicate()
	global_weapon_pool = weapons.duplicate()
	global_corrupted_pool = corrupted_abilities.duplicate()
	for ability in global_ability_pool:
		if ability.guaranteed_at == 0:
			continue
		
		if guarantees.find_key(ability.guaranteed_at) == null:
			guarantees[ability.guaranteed_at] = []
		
		guarantees[ability.guaranteed_at].push_back(ability)
	
	initialized = true

## Picks a certain number of random weapons from the weapon pool.
func get_weapon_selection(count: int = 3) -> Array[AbilityInfo]:
	if !initialized:
		_init_pool()

	var weapon_pool = _get_weapon_pool()
	var choices: Array[AbilityInfo] = []
	for i in range(count):
		var index = randi_range(0, weapon_pool.size() - 1)
		choices.push_back(weapon_pool[index])
		weapon_pool.remove_at(index)
	return choices

func get_corrupted_abilities(count: int = 3) -> Array[AbilityInfo]:
	if !initialized:
		_init_pool()

	var corrupted_pool = _get_corrupted_pool()
	var choices: Array[AbilityInfo] = []
	for i in range(count):
		var index = randi_range(0, corrupted_pool.size() - 1)
		choices.push_back(corrupted_pool[index])
		corrupted_pool.remove_at(index)
	return choices

func get_ability_selection(count: int = 3) -> Array[AbilityInfo]:
	if !initialized:
		_init_pool()

	var player_level = GameManager.get_player().experience.current_level
	# If the player is at a weapon breakpoint, give them a weapon instead of a skill.
	if player_level in weapon_guarantee_breakpoints:
		return get_weapon_selection(count)

	var ability_pool = _get_ability_pool()
	ability_pool = _filter_unavailable_abilities(ability_pool)
	var picked_abilities: Array[AbilityInfo] = []
	var guaranteed_picks = guarantees.get(player_level)
	
	if guaranteed_picks != null:
		for pick in guaranteed_picks:
			picked_abilities.push_back(pick)

	for i in range(min(count - picked_abilities.size(), ability_pool.size())):
		var accumulator = _create_ability_accumulator(ability_pool)
		var accumulator_total: int = accumulator[-1]
		var desired_weight: int = randi_range(0, accumulator_total)
		var index_of_ability: int = -1
		for j in accumulator.size():
			var weight = accumulator[j]
			if weight == desired_weight or weight <= desired_weight and accumulator[j + 1] > desired_weight:
				index_of_ability = j
				break
		var ability: AbilityInfo = ability_pool[index_of_ability]
		ability_pool.pop_at(index_of_ability)
		picked_abilities.push_back(ability)
	
	return picked_abilities

## Returns the ability pool associated with the provided ability.
func get_pool(ability: AbilityInfo) -> Array[AbilityInfo]:
	var pool: Array[AbilityInfo] = []
	match ability.type:
		AbilityInfo.AbilityType.WEAPON: pool = global_weapon_pool
		AbilityInfo.AbilityType.PASSIVE: pool = global_ability_pool
		AbilityInfo.AbilityType.CORRUPTED: pool = corrupted_abilities
		_:
			assert(false, "Invalid AbilityInfo.type")
	return pool

## Increments the counter for how many instances of a specific ability the player has.
## If the player has reached the maximum number of instances, the ability is removed from
## the global pool.
func add_ability_pick_count(ability: AbilityInfo):
	var pick_count = pick_counts.get(ability)
	if pick_count == null:
		pick_counts[ability] = 0
	
	pick_counts[ability] += 1
	
	if ability.max_amount > 0 and pick_counts[ability] >= ability.max_amount:
		var pool = get_pool(ability)
		var ability_index: int = pool.find(ability)
		pool.remove_at(ability_index)

func _filter_unavailable_abilities(to_filter: Array[AbilityInfo]) -> Array[AbilityInfo]:
	var available: Array[AbilityInfo] = []
	for ability in to_filter:
		var include: bool = true
		for requirement in ability.requirements:
			if requirement not in pick_counts.keys():
				include = false
				break
		if include:
			available.push_back(ability)
	return available
