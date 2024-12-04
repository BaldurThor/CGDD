extends Ability

const SPEAR_GUN = preload("res://player/gun/gun_types/spear_gun/spear_gun.tres")
const BULLET = preload("res://player/gun/bullets/basic/bullet.tscn")

func apply_effects(player_stats: PlayerStats) -> void:
	player.weapon_manager.add_weapon(SPEAR_GUN, BULLET)
