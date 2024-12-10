extends Node

signal pick_ability(amount : int)
signal pick_corrubted_ability(amount : int)

func toggle_debug() -> String:
	Debug.enable = not Debug.enable
	
	return "Debug.enable : " + str(Debug.enable)

func add_xp(amount: int) -> String:
	GameManager.get_player().experience.gain_experience.emit(amount)
	return "Added %d XP" % [amount]

func get_ability_picker() -> String:
	pick_ability.emit(3)
	return "uwu"
