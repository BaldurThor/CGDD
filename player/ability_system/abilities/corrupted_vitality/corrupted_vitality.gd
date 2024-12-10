extends Ability

func apply_effects(player_stats: PlayerStats) -> void:
	player_stats.can_regen = false
	player_stats.max_health_mod += 1.0
