class_name MeleeDamageCalculation extends Node

@onready var melee: Melee = $".."

func calculate_damage() -> int:
	var group = melee.weapon_group
	var damage = group.get_base_damage()
	var crit_chance = group.get_crit_chance()
	var is_crit: bool = randf() < crit_chance
	if is_crit:
		if !group.player_stats.crits_deal_damage:
			return 0
		damage *= group.get_crit_multiplier()
		return max(1, int(damage))
	return max(1, int(damage)) * group.player_stats.non_crit_damage_multiplier

func calculate_knockback() -> int:
	return melee.weapon_group.get_knockback()
