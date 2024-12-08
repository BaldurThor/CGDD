extends Ability

func apply_effects(player_stats: PlayerStats) -> void:
	player_stats.extra_projectiles += 1
	player_stats.ranged_range_mod -= 0.15
	player_stats.ranged_spread_mod += 0.1
	player_stats.damage_mod -= 0.15
