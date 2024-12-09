extends Ability

func apply_effects(player_stats: PlayerStats) -> void:
	player_stats.absolute_max_dodge = 0.0
	player_stats.absolute_max_armor = 0
	player_stats.experience_gain_mod += 1.5
