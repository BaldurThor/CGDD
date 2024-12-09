class_name ProjectileTravelBehavior extends Node

@onready var projectile: Projectile = $".."
## Should the projectile stop moving on impact?
@export var stop_on_impact: bool = false
## Should the projectile's sprite face the travel direction?
@export var face_direction: bool = false

var _impacted: bool = false

func _ready() -> void:
	projectile.body_entered.connect(_handle_impact)
	if face_direction:
		projectile.look_at(projectile.direction)

func _handle_impact(_collided_with: Node2D) -> void:
	_impacted = true

func _physics_process(delta: float) -> void:
	if stop_on_impact and _impacted:
		return
	projectile.position += projectile.direction * projectile.weapon_type.projectile_speed * delta
