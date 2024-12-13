extends Ability

func apply_effects(player_stats: PlayerStats) -> void:
	player_stats.max_health_mod += 0.10
	player_stats.armor += 3
	player_stats.dodge_chance -= 0.05
	player_stats.movement_speed_mod -= 0.10
