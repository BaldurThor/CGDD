class_name AbilityPool extends Resource

@export var abilities: Array[AbilityInfo] = []

var global_ability_pool: Array[AbilityInfo] = []
var pick_counts: Dictionary = {}

# Workaround for not having a _ready() function in the resource
var initialized: bool = false

func _pick_ability(ability_pool: Array[AbilityInfo]) -> AbilityInfo:
	while ability_pool.size() > 0:
		return ability_pool.pop_front()
	
	return null

func _get_ability_pool() -> Array[AbilityInfo]:
	# TODO: Make this shuffle based on rarity. Least rare should generally be
	# placed more in the front.
	var ability_pool = global_ability_pool.duplicate()
	ability_pool.shuffle()
	return ability_pool

func get_ability_selection(count: int = 3) -> Array[AbilityInfo]:
	if !initialized:
		global_ability_pool = abilities.duplicate()
		initialized = true
	
	var ability_pool = _get_ability_pool()
	var picked_abilities: Array[AbilityInfo] = []
	
	for i in range(min(count, ability_pool.size())):
		picked_abilities.push_back(ability_pool.pop_front())
	
	return picked_abilities

func add_ability_pick_count(ability: AbilityInfo):
	var pick_count = pick_counts.find_key(ability)
		
	if pick_count == null:
		pick_counts[ability] = 0
	
	pick_counts[ability] += 1
	
	if ability.max_amount > 0 and pick_counts[ability] >= ability.max_amount:
		var ability_index: int = global_ability_pool.find(ability)
		global_ability_pool.remove_at(ability_index)
