extends Ability

func apply_effects(player_stats: PlayerStats) -> void:
	player_stats.dodge_chance += 0.05
	player_stats.armor += 1
