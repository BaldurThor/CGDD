extends Ability

func apply_effects(player_stats: PlayerStats, player_health: EntityHealth) -> void:
	player_health.max_health += 10
