class_name HeartOfDarkness extends PickupBase

func pickup() -> void:
	GameManager.get_player().ability_selector.request_corrupted()
	super()

## No need for a value here.
func assign_value(_value: int) -> void:
	pass
