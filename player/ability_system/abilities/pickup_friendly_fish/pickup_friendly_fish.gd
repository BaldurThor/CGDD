extends Ability


func apply_effects(_player_stats: PlayerStats) -> void:
	var weapon = load("res://player/weapons/orbital_melee/friendly_fish/friendly_fish.tres")
	player.weapon_group_manager.add_weapon("friendly_fish", WeaponGroupManager.WeaponArchetype.ORBITAL_MELEE, weapon)
