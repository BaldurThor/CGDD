extends Ability


func apply_effects(_player_stats: PlayerStats) -> void:
	var weapon = load("res://player/weapons/melee/metal_baseball_bat/metal_baseball_bat.tres")
	player.weapon_group_manager.add_weapon("baseball_bat", WeaponGroupManager.WeaponArchetype.MELEE, weapon)
