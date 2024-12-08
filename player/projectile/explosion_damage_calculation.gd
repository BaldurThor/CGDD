class_name ExplosionDamageCalculation extends Node

# Projectile or Explosion
@onready var explosion: Area2D = $".."

var _player_stats: PlayerStats = null
var _weapon_type: WeaponType = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_player_stats = explosion.player_stats
	_weapon_type = explosion.weapon_type

func calculate() -> int:
	var base_damage = (_weapon_type.damage + _player_stats.added_explosive_damage) * (_weapon_type.damage_effectiveness + _player_stats.explosive_damage_mod + _player_stats.damage_mod)
	var crit_chance = _weapon_type.crit_chance + _player_stats.crit_chance
	var damage: float = float(base_damage) * _player_stats.damage_mod
	var is_crit: bool = randf() < crit_chance
	if is_crit:
		damage *= float(_weapon_type.crit_damage + _player_stats.crit_multiplier)
	return max(1, int(damage))
