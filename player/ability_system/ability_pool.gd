class_name AbilityPool extends Resource

@export var abilities: Array[AbilityInfo] = []

func pick_ability() -> AbilityInfo:
	return abilities.pick_random()
