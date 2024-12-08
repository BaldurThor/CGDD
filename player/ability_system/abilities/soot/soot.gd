extends Ability

func apply_effects(player_stats: PlayerStats) -> void:
	player_stats.explosive_damage_mod += 0.10
	player_stats.added_explosive_damage += 5
