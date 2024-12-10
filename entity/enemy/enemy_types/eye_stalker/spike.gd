class_name Spike extends Area2D

@export var damage_on_hit: int = 0
@export var projectile_speed: float = 70.0
@onready var damage_calculation: SpikeDamageCalculation = $DamageCalculation

var direction: Vector2
var entity_stats: EntityStats

signal despawn()

func init(stats: EntityStats, bullet_direction: Vector2) -> void:
	entity_stats = stats
	direction = bullet_direction.normalized()

func calculate_damage() -> int:
	return damage_calculation.calculate_damage()
