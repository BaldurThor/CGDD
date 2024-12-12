class_name ProjectilePrimaryDamageCalculation extends Node

@onready var projectile: Projectile = $".."

var _player_stats: PlayerStats = null
var _weapon_type: WeaponType = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_player_stats = projectile.player_stats
	_weapon_type = projectile.weapon_type

func calculate_damage() -> int:
	var base_damage = (_weapon_type.damage + _player_stats.added_ranged_damage) * _weapon_type.damage_effectiveness
	var crit_chance = min(_player_stats.absolute_max_crit_chance, _weapon_type.crit_chance + _player_stats.crit_chance)
	var damage: float = float(base_damage) * _player_stats.damage_mod
	var is_crit: bool = randf() < crit_chance
	if is_crit:
		GameManager.got_crit.emit()
		if !_player_stats.crits_deal_damage:
			return 0
		damage *= float(_weapon_type.crit_damage + _player_stats.crit_multiplier)
		return max(1, int(damage))
	return max(1, int(damage)) * _player_stats.non_crit_damage_multiplier

func calculate_knockback() -> int:
	if _weapon_type.can_knockback:
		return int(_weapon_type.knockback)
	return 0
