extends Ability

func apply_effects(player_stats: PlayerStats) -> void:
	player_stats.max_health_mod += 0.10
	player_stats.added_melee_strikes += 1
	player_stats.added_melee_knockback += 0.1
	player_stats.attack_speed_mod -= 0.10
