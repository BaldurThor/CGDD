extends Ability


func apply_effects(_player_stats: PlayerStats) -> void:
	var weapon = load("res://player/weapons/gun/gun_types/frag_grenade/frag_grenade_thrower.tres")
	player.weapon_group_manager.add_weapon("frag_grenade", WeaponGroupManager.WeaponArchetype.FIREARM, weapon)
