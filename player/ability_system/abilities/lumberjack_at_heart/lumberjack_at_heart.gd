extends Ability

func apply_effects(player_stats: PlayerStats) -> void:
	player_stats.armor += 2
	player_stats.regen_speed_mod += 0.1
	player_stats.ranged_spread_mod += 0.25
	player_stats.ranged_attack_speed_mod -= 0.15
