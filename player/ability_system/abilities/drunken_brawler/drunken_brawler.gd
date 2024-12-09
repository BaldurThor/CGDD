extends Ability

func apply_effects(player_stats: PlayerStats) -> void:
	player_stats.crit_chance += 0.05
	player_stats.crit_multiplier += 0.10
	player_stats.ranged_spread_mod += 0.15
