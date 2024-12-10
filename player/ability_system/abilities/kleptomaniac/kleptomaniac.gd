extends Ability

func apply_effects(player_stats: PlayerStats) -> void:
	player_stats.experience_absorb_range_mod += 0.80
	player_stats.experience_orb_absorb_speed_mod += 2.0
