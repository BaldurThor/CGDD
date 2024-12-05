extends Ability

func apply_effects(player_stats: PlayerStats) -> void:
	player_stats.added_ranged_damage += 3
	player_stats.ranged_attack_speed_mod += 0.05
	player_stats.ranged_spread_mod += 0.05
