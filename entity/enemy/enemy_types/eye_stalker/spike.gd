class_name Spike extends Area2D

@export var damage_on_hit: int = 0
@export var projectile_speed: float = 70.0
@onready var damage_calculation: SpikeDamageCalculation = $DamageCalculation

var direction: Vector2
var entity_stats: EntityStats
var enemy: Enemy

signal despawn

func init(enemy_instance: Enemy, bullet_direction: Vector2) -> void:
	enemy = enemy_instance
	entity_stats = enemy.entity_stats
	direction = bullet_direction.normalized()

func calculate_damage() -> int:
	return damage_calculation.calculate_damage()
