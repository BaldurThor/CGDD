extends Ability

func apply_effects(player_stats: PlayerStats) -> void:
	player_stats.extra_projectile_pierce += 3
	player_stats.added_ranged_damage += 3
	player_stats.dodge_chance += 0.05
