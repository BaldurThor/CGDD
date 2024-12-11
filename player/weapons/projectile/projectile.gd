class_name Projectile extends Area2D

var direction: Vector2
var weapon_type: WeaponType
var player_stats: PlayerStats
var timer: Timer

## Standalone node which returns the damage that each projectile should deal.
@onready var damage_calculation: Node = $DamageCalculation

signal despawn

func init(weapon: WeaponType, stats: PlayerStats, bullet_direction: Vector2) -> void:
	weapon_type = weapon
	player_stats = stats
	direction = bullet_direction.normalized()

func _ready() -> void:
	timer = Timer.new()
	timer.wait_time = 5.0
	timer.process_mode = PROCESS_MODE_PAUSABLE
	add_child(timer)
	timer.start()
	await timer.timeout
	queue_free()

func calculate_damage() -> int:
	return damage_calculation.calculate_damage()

func calculate_knockback() -> float:
	return damage_calculation.calculate_knockback()
