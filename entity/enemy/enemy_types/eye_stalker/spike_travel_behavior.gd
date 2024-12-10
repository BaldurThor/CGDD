class_name SpikeTravelBehavior extends Node

@onready var spike: Spike = $".."

var _impacted: bool = false

func _ready() -> void:
	spike.body_entered.connect(_handle_impact)
	spike.look_at(spike.direction)

func _handle_impact(_collided_with: Node2D) -> void:
	_impacted = true

func _physics_process(delta: float) -> void:
	spike.position += spike.direction * spike.projectile_speed * delta
