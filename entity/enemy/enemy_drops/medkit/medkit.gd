class_name Medkit extends PickupBase

@export var medkit_heal_amount: int = 1

func pickup() -> void:
	_player.player_stats.heal_player.emit(medkit_heal_amount, false)
	super()

func assign_value(value: int) -> void:
	medkit_heal_amount = value
