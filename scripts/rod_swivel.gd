extends Node2D

@export_category("Hook power")
@export var min_power : int = 5
@export var max_power : int = 50

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		print("click")
