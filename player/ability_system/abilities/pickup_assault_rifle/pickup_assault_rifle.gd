extends Ability


func apply_effects(_player_stats: PlayerStats) -> void:
	var weapon = load("res://player/weapons/gun/gun_types/assault_rifle/assault_rifle.tres")
	player.weapon_group_manager.add_weapon("assault_rifle", WeaponGroupManager.WeaponArchetype.FIREARM, weapon)
