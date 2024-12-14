class_name ProjectileSecondaryDamageCalculation extends Node

@onready var projectile: Projectile = $".."

func calculate_damage() -> int:
	var group = projectile.weapon_group
	var base_damage = (group.weapon_type.secondary_damage + group.player_stats.added_ranged_damage + group.secondary_added_damage) * group.weapon_type.secondary_damage_effectiveness
	var crit_chance = projectile.weapon_group.get_crit_chance()
	var damage: float = float(base_damage) * group.player_stats.damage_mod
	var is_crit: bool = randf() < crit_chance
	if is_crit:
		if !group.player_stats.crits_deal_damage:
			return 0
		damage *= float(group.weapon_type.crit_damage + group.player_stats.crit_multiplier)
		return max(1, int(damage))
	return max(1, int(damage)) * group.player_stats.non_crit_damage_multiplier

func calculate_knockback() -> int:
	return projectile.weapon_group.get_secondary_knockback()
