@icon("res://entity/enemy/enemy_actions/behaviour_tree_icon.svg")
class_name LogicTree extends Node

@onready var enemy: Enemy = $".."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if GameManager.freeze_enemies:
		return
	
	for child in get_children():
		if child.evaluate():
			child.execute_logic()
			break
