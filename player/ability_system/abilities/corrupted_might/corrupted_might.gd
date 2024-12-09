extends Ability

func apply_effects(player_stats: PlayerStats) -> void:
	player_stats.crits_deal_damage = false
	player_stats.damage_mod += 1.0
	player_stats.crit_chance += 0.25
	player_stats.explosive_damage_mod -= 0.80
