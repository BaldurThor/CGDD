extends Ability

const SPEAR_GUN = preload("res://player/gun/gun_types/spear_gun/spear_gun.tres")
const SPEAR_GUN_SPEAR = preload("res://player/gun/bullets/spear_gun_spear/spear_gun_spear.tscn")

func apply_effects(_player_stats: PlayerStats) -> void:
	player.weapon_manager.add_weapon(SPEAR_GUN, SPEAR_GUN_SPEAR)
