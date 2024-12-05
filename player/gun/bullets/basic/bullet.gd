class_name Bullet extends Area2D

## The time before the bullet automatically despawns
@export var despawn_delay: float
@export var bullet_behaviour: Script

@onready var despawn_timer: Timer = $DespawnTimer

var direction: Vector2
var _weapon_type: WeaponType
var _player_stats: PlayerStats
var hit_count: int = 0

func init(weapon_type: WeaponType, player_stats: PlayerStats, bullet_direction: Vector2) -> void:
	_weapon_type = weapon_type
	_player_stats = player_stats
	direction = bullet_direction

func _ready() -> void:
	despawn_timer.wait_time = despawn_delay

func _process(delta: float) -> void:
	position += direction.normalized() * _weapon_type.projectile_speed * delta

func _on_body_entered(body: Node) -> void:
	if body is Enemy:
		body.take_damage(_calculate_damage())
		# If the bullet has pierced a certain number of times, delete it.
		if _weapon_type.pierce_count > hit_count:
			hit_count += 1
		else:
			queue_free()

func _on_despawn_timer_timeout() -> void:
	queue_free()

func _calculate_damage() -> int:
	var base_damage = (_weapon_type.damage * _weapon_type.damage_effectiveness) + _player_stats.added_ranged_damage
	var crit_chance = _weapon_type.crit_chance + _player_stats.crit_chance
	var damage = base_damage * _player_stats.damage_mod
	var is_crit: bool = randf() < crit_chance
	if is_crit:
		damage *= (_weapon_type.crit_damage + _player_stats.crit_multiplier)
	return max(1, int(damage))
