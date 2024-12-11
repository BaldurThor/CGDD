extends Ability

func apply_effects(player_stats: PlayerStats) -> void:
	player_stats.item_absorb_range_mod += 0.80
