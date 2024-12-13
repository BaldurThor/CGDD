extends Ability

func apply_effects(player_stats: PlayerStats) -> void:
	player_stats.movement_speed_mod += 0.10
	player_stats.dodge_chance += 0.08
