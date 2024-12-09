extends Ability

func apply_effects(player_stats: PlayerStats) -> void:
	player_stats.can_dodge = false
	player_stats.can_have_armor = false
	player_stats.experience_gain_mod += 1.5
