extends Ability

func apply_effects(player_stats: PlayerStats) -> void:
	player_stats.regen_amount_flat += 1
	player_stats.max_health += 5
	player_stats.regen_speed_mod += 0.03
