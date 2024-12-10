extends Ability

func apply_effects(player_stats: PlayerStats) -> void:
	player_stats.crit_chance += 0.05
	player_stats.added_melee_damage += 3
	player_stats.melee_attack_speed_mod += 0.05
	player_stats.armor -= 3
