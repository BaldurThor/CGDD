extends Ability

func apply_effects(player_stats: PlayerStats) -> void:
	player_stats.dodge_chance += 5.0
