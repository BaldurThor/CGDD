extends Ability

func apply_effects(player_stats: PlayerStats) -> void:
	player_stats.max_health_mod -= 0.15
	player_stats.melee_attack_speed_mod += 0.2
	player_stats.melee_range_mod += 0.15
