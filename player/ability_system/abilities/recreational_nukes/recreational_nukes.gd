extends Ability

func apply_effects(player_stats: PlayerStats) -> void:
	player_stats.explosive_radius_mod += 0.25
	player_stats.explosive_damage_mod += 0.25
