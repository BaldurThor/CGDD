class_name SpikeDespawnBehavior extends Node

@onready var spike: Spike = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spike.despawn.connect(_handle_despawn)

func _handle_despawn() -> void:
	spike.queue_free.call_deferred()
