extends Ability

func apply_effects(player_stats: PlayerStats) -> void:
	var group = player.weapon_group_manager.get_weapon_group("friendly_fish")
	if group == null:
		print_debug("WARNING: FRIENDLY FISH WEAPON GROUP WAS NOT FOUND!")
		return
	
	group.added_melee_strikes += 4
	group.primary_added_damage += 5
