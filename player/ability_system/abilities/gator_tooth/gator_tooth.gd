extends Ability

func apply_effects(player_stats: PlayerStats) -> void:
	player_stats.crit_chance += 1.0
