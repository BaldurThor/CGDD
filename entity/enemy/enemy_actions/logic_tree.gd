class_name LogicTree extends Node

@onready var enemy = $".."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	for child in get_children():
		if child.evaluate():
			child.execute_logic()
			break
