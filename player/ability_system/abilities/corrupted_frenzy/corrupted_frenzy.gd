extends Ability

func apply_effects(player_stats: PlayerStats) -> void:
	player_stats.attack_speed_mod += 0.50
	player_stats.movement_speed_mod += 0.20
	player_stats.ranged_range_mod -= 0.40
	player_stats.melee_range_mod -= 0.40
	player_stats.explosive_radius_mod -= 0.40
