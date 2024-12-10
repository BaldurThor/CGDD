extends Ability

func apply_effects(player_stats: PlayerStats) -> void:
	player_stats.added_melee_strikes += 2
	player_stats.added_melee_damage += 3
	player_stats.movement_speed_mod += 0.10
