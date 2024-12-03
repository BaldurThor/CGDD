extends Ability

func apply_effects(player_stats: PlayerStats) -> void:
	player_stats.max_health += 10
