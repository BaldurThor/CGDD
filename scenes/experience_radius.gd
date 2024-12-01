class_name ExperienceRange extends Area2D

@onready var player: Player = $".."

func _on_body_entered(body: Node2D) -> void:
	if body is ExperienceGem:
		body.start_tracking_player()
