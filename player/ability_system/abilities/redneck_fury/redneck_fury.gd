extends Ability

func apply_effects(player_stats: PlayerStats) -> void:
	player_stats.attack_speed_mod += 1.0
	player_stats.max_health_mod -= 0.75
