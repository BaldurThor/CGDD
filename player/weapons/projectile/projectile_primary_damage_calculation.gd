class_name ProjectilePrimaryDamageCalculation extends Node

@onready var projectile: Projectile = $".."

func calculate_damage() -> int:
	var damage = projectile.weapon_group.get_base_damage()
	var crit_chance = min(
		projectile.weapon_group.player_stats.absolute_max_crit_chance,
		projectile.weapon_group.get_crit_chance()
	)
	var is_crit: bool = randf() < crit_chance
	if is_crit:
		GameManager.got_crit.emit()
		if !projectile.weapon_group.player_stats.crits_deal_damage:
			return 0
		damage *= projectile.weapon_group.get_crit_multiplier()
		return max(1, int(damage))
	return max(1, int(damage)) * projectile.weapon_group.player_stats.non_crit_damage_multiplier

func calculate_knockback() -> int:
	if projectile.weapon_group.weapon_type.can_knockback:
		return int(projectile.weapon_group.weapon_type.knockback)
	return 0
