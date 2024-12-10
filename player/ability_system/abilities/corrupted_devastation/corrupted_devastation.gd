extends Ability

func apply_effects(player_stats: PlayerStats) -> void:
	player_stats.armor += 25
	player_stats.explosive_damage_mod += 0.5
	player_stats.explosive_radius_mod += 0.5
	player_stats.absolute_max_dodge = -0.01
	player_stats.max_health_mod -= 0.5
	player_stats.regen_speed_mod -= 0.5
