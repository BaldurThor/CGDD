extends Ability

func apply_effects(player_stats: PlayerStats) -> void:
	player_stats.explosive_radius_mod += 0.10
	player_stats.explosive_damage_mod += 0.05
	player_stats.attack_speed_mod -= 0.05
