extends Ability

func apply_effects(_player_stats: PlayerStats) -> void:
	var group = player.weapon_group_manager.get_weapon_group("shotgun")
	if group == null:
		print_debug("WARNING: SHOTGUN WEAPON GROUP WAS NOT FOUND!")
		return
	
	group.added_projectiles += 5
	group.added_crit_multiplier += 0.50
