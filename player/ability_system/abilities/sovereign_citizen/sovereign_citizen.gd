extends Ability

func apply_effects(player_stats: PlayerStats) -> void:
	player_stats.added_melee_damage += 3
	player_stats.added_explosive_damage += 3
	player_stats.added_ranged_damage += 3
