extends Ability

func apply_effects(player_stats: PlayerStats) -> void:
	player_stats.extra_projectiles += 2
	player_stats.crit_multiplier += 0.15
	player_stats.ranged_attack_speed_mod -= 0.2
	player_stats.crit_chance -= 0.05
