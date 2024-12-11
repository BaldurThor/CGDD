class_name Medkit extends PickupBase

@export var medkit_heal_amount: int = 1

func pickup() -> void:
	_player.player_stats.medkit_picked_up.emit(medkit_heal_amount)
	super()

func assign_value(value: int) -> void:
	medkit_heal_amount = value
