extends Ability

func apply_effects(player_stats: PlayerStats) -> void:
	player_stats.explosive_damage += 5
	player_stats.added_explosive_radius += 20
	player_stats.max_health_mod -= 0.10
