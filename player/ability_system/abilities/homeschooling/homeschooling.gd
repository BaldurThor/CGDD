extends Ability

func apply_effects(player_stats: PlayerStats) -> void:
	player_stats.max_health += 7
	player_stats.armor += 1
	player_stats.movement_speed_mod += 0.05
