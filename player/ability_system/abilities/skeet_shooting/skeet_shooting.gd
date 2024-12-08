extends Ability

func apply_effects(player_stats: PlayerStats) -> void:
	player_stats.ranged_range_mod += 0.15
	player_stats.ranged_spread_mod -= 0.05
