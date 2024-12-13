extends Ability

func apply_effects(_player_stats: PlayerStats) -> void:
	var group = player.weapon_group_manager.get_weapon_group("pistol")
	if group == null:
		print_debug("WARNING: PISTOL WEAPON GROUP WAS NOT FOUND!")
		return
	
	group.added_range_mod += 0.25
	group.attack_speed_mod += 0.50
	group.added_crit_chance += 0.08
