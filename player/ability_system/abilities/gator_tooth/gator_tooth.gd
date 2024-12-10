extends Ability

func apply_effects(player_stats: PlayerStats) -> void:
	player_stats.crit_chance += 0.08
	player_stats.crit_multiplier += 0.05
