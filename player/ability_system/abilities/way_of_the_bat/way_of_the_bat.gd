extends Ability

func apply_effects(player_stats: PlayerStats) -> void:
	var group = player.weapon_group_manager.get_weapon_group("baseball_bat")
	if group == null:
		print_debug("WARNING: METAL BASEBALL BAT WEAPON GROUP WAS NOT FOUND!")
		return
	
	group.added_melee_strikes += 2
	group.primary_added_damage += 3
	player_stats.movement_speed_mod += 0.10
