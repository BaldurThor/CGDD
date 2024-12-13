extends Ability

func apply_effects(_player_stats: PlayerStats) -> void:
	var group = player.weapon_group_manager.get_weapon_group("assault_rifle")
	if group == null:
		print_debug("WARNING: ASSAULT RIFLE WEAPON GROUP WAS NOT FOUND!")
		return
	
	group.primary_added_damage += 4
	group.added_projectiles += 2
	group.added_crit_multiplier += 0.15
