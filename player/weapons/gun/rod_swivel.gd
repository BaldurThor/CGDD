extends Node2D

@onready var hook: Hook = $hook
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if hook.angle == -1:
		look_at(get_global_mouse_position())
