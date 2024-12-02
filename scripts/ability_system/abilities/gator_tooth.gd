extends Ability

func apply_effects(player_stats: PlayerStats, player_health: EntityHealth) -> void:
	player_stats.crit_chance += 1
