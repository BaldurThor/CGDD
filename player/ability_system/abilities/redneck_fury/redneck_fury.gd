extends Ability

func apply_effects(player_stats: PlayerStats, player_health: EntityHealth) -> void:
	player_stats.attack_speed *= 2.0
	player_health.max_health /= 4.0
