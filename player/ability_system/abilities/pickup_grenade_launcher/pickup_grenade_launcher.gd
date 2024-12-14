extends Ability

func apply_effects(_player_stats: PlayerStats) -> void:
	var weapon = load("res://player/weapons/gun/gun_types/grenade_launcher/grenade_launcher.tres")
	player.weapon_group_manager.add_weapon("grenade_launcher", WeaponGroupManager.WeaponArchetype.EXPLOSIVE_RANGED, weapon)
