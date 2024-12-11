class_name PickupRadius extends Area2D

# The radius of which the experience gems are actually picked up.
# This radius should not be changed at runtime.

@onready var experience: Experience = $".."

func _on_body_entered(body: Node2D) -> void:
	if body is PickupBase:
		body.pickup()
