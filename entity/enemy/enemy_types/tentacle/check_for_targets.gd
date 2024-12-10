extends LogicNode

@export var area_2d: Area2D

func evaluate() -> bool:
	return area_2d.get_overlapping_bodies().size() > 0

func execute_logic() -> void:
	for child in get_children():
		if child.evaluate():
			child.execute_logic()
			break
