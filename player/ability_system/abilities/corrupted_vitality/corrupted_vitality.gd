extends Ability

func apply_effects(player_stats: PlayerStats) -> void:
	player_stats.absolute_max_health_regen = 0
	player_stats.max_health_mod += 1.25
