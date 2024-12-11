extends Ability

func apply_effects(player_stats: PlayerStats) -> void:
	player_stats.ranged_attack_speed_mod += 0.10
	player_stats.ranged_range_mod += 0.10
