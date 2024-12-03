extends Ability

func apply_effects(player_stats: PlayerStats) -> void:
	player_stats.attack_speed *= 2.0
	player_stats.max_health /= 4.0
