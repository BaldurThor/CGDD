class_name ProjectileImpactBehavior extends Node

@onready var projectile: Projectile = $".."
@export var deal_damage: bool = true
@export var disable_collision_on_impact: bool = false
@export var despawn_on_hit: bool = true
## If despawn_on_hit is false, this timer will determine the projectile's lifetime.
@export var time_before_despawn: float = 0.0

var collision_count: int = 0
var can_pierce: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	can_pierce = projectile.weapon_type.pierce_count > 0
	projectile.body_entered.connect(_handle_impact)
	if !despawn_on_hit and time_before_despawn > 0.0:
		get_tree().create_timer(time_before_despawn).timeout.connect(_on_timeout)

func _handle_impact(collided_with: Node2D) -> void:
	if collided_with is Enemy:
		if deal_damage:
			collided_with.take_damage(projectile.calculate_damage())
		if disable_collision_on_impact:
			projectile.collision_layer = 0
			projectile.collision_mask = 0
		collision_count += 1
		if despawn_on_hit or (can_pierce and projectile.weapon_type.pierce_count == collision_count - 1):
			projectile.despawn.emit()

func _on_timeout() -> void:
	projectile.despawn.emit()
