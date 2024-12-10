extends Ability

func apply_effects(player_stats: PlayerStats) -> void:
	player_stats.absolute_max_dodge = -0.01
	player_stats.absolute_max_armor = 1
	player_stats.experience_gain_mod += 1.5
