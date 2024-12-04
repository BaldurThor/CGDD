class_name AbilityPool extends Resource

@export var abilities: Array[AbilityInfo] = []

var global_ability_pool: Array[AbilityInfo] = []
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
	# TODO: Make this shuffle based on rarity. Least rare should generally be
	# placed more in the front.
	var ability_pool = global_ability_pool.duplicate()
	ability_pool.shuffle()
	return ability_pool

func _init_pool():
	global_ability_pool = abilities.duplicate()
	for ability in global_ability_pool:
		if ability.guaranteed_at == 0:
			continue
		
		if guarantees.find_key(ability.guaranteed_at) == null:
			guarantees[ability.guaranteed_at] = []
		
		guarantees[ability.guaranteed_at].push_back(ability)
	
	initialized = true

func get_ability_selection(count: int = 3) -> Array[AbilityInfo]:
	if !initialized:
		_init_pool()
	
	var ability_pool = _get_ability_pool()
	var picked_abilities: Array[AbilityInfo] = []
	
	var player_level = GameManager.get_player().experience.current_level
	var guaranteed_picks = guarantees.get(player_level)
	if guaranteed_picks != null:
		for pick in guaranteed_picks:
			picked_abilities.push_back(pick)
	
	for i in range(min(count - picked_abilities.size(), ability_pool.size())):
		picked_abilities.push_back(ability_pool.pop_front())
	
	return picked_abilities

func add_ability_pick_count(ability: AbilityInfo):
	var pick_count = pick_counts.get(ability)
		
	if pick_count == null:
		pick_counts[ability] = 0
	
	pick_counts[ability] += 1
	
	if ability.max_amount > 0 and pick_counts[ability] >= ability.max_amount:
		var ability_index: int = global_ability_pool.find(ability)
		global_ability_pool.remove_at(ability_index)
