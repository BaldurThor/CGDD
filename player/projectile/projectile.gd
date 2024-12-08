class_name Projectile extends Area2D

var direction: Vector2
var weapon_type: WeaponType
var player_stats: PlayerStats

signal despawn()

func init(weapon: WeaponType, stats: PlayerStats, bullet_direction: Vector2) -> void:
	weapon_type = weapon
	player_stats = stats
	direction = bullet_direction.normalized()

func calculate_damage() -> int:
	var base_damage = (weapon_type.damage * weapon_type.damage_effectiveness) + player_stats.added_ranged_damage
	var crit_chance = weapon_type.crit_chance + player_stats.crit_chance
	var damage: float = float(base_damage) * player_stats.damage_mod
	var is_crit: bool = randf() < crit_chance
	if is_crit:
		damage *= float(weapon_type.crit_damage + player_stats.crit_multiplier)
	return max(1, int(damage))
