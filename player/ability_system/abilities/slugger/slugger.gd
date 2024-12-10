extends Ability

func apply_effects(player_stats: PlayerStats) -> void:
	player_stats.melee_range_mod += 0.15
	player_stats.added_melee_damage += 3
