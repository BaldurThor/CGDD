extends Node

signal pick_ability(amount : int)

func toggle_debug() -> String:
	Debug.enable = not Debug.enable
	
	return "Debug.enable : " + str(Debug.enable)

func add_xp(amount: int) -> String:
	GameManager.get_player().experience.gain_experience.emit(amount)
	return "Added %d XP" % [amount]

func get_ability_picker(type : int = 1) -> String:
	pick_ability.emit(type)
	return "got an ability picker"
