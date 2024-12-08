extends Ability

func apply_effects(player_stats: PlayerStats) -> void:
	player_stats.experience_absorb_range_mod += 0.25
	player_stats.experience_gain_mod += 0.1
