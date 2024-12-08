class_name Projectile extends Area2D

var direction: Vector2
var weapon_type: WeaponType
var player_stats: PlayerStats

## Standalone node which returns the damage that each projectile should deal.
@onready var damage_calculation: Node = $DamageCalculation

signal despawn()

func init(weapon: WeaponType, stats: PlayerStats, bullet_direction: Vector2) -> void:
	weapon_type = weapon
	player_stats = stats
	direction = bullet_direction.normalized()

func calculate_damage() -> int:
	return damage_calculation.calculate()
