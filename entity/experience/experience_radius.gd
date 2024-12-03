class_name ExperienceRange extends Area2D

# The radius at which the gems are drawn towards the player.
# This radius may be changed at runtime.

@onready var player: Player = $"../.."

func _on_body_entered(body: Node2D) -> void:
	if body is ExperienceGem:
		body.start_tracking_player()
