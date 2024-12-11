extends Ability


func apply_effects(_player_stats: PlayerStats) -> void:
	var weapon = load("res://player/weapons/gun/gun_types/dynamite/dynamite_thrower.tres")
	player.weapon_group_manager.add_weapon("dynamite", WeaponGroupManager.WeaponArchetype.FIREARM, weapon)
