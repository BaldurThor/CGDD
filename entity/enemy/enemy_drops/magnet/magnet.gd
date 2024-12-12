class_name Magnet extends PickupBase


func pickup() -> void:
	for node in get_tree().get_nodes_in_group("experience"):
		node.start_tracking_player()
	super()

## Magnet doesn't need any values.
func assign_value(_value: Variant) -> void:
	pass
