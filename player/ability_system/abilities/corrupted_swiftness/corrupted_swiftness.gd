extends Ability

func apply_effects(player_stats: PlayerStats) -> void:
	player_stats.absolute_max_health = 1
	player_stats.dodge_chance += 0.5
	player_stats.movement_speed_mod += 0.5
