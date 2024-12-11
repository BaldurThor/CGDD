class_name ExplosionDamageCalculation extends Node

# Projectile or Explosion
@onready var explosion: Area2D = $".."

var _player_stats: PlayerStats = null
var _weapon_type: WeaponType = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_player_stats = explosion.player_stats
	_weapon_type = explosion.weapon_type

## Calculate the damage for the explosion. Explosives cannot crit, but their secondary effects may.
func calculate_damage() -> int:
	var base_damage = (_weapon_type.damage + _player_stats.added_explosive_damage) * (_weapon_type.damage_effectiveness)
	var damage: float = float(base_damage) * (_player_stats.damage_mod + _player_stats.explosive_damage_mod)
	return max(1, int(damage)) * _player_stats.non_crit_damage_multiplier

func calculate_knockback() -> int:
	if _weapon_type.can_knockback:
		return _weapon_type.knockback
	return 0
