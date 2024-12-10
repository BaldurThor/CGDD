extends Ability

func apply_effects(player_stats: PlayerStats) -> void:
	player_stats.added_melee_damage += 5
	player_stats.added_melee_strikes += 3
	player_stats.melee_attack_speed_mod -= 0.5
	player_stats.melee_range_mod -= 0.5
