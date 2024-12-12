extends AnimationPlayer

@export var default_move_speed: float = 300

func move_anim(speed: float) -> void:
	self.speed_scale = speed / default_move_speed
	self.play("Move")

func _on_animation_changed(old_name: StringName, new_name: StringName) -> void:
	if old_name == "Move":
		self.speed_scale = 1.
