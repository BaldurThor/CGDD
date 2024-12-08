extends Ability

const PISTOL = preload("res://player/gun/gun_types/pistol/pistol.tres")
const BULLET = preload("res://player/gun/bullets/basic/bullet.tscn")

func apply_effects(_player_stats: PlayerStats) -> void:
	player.weapon_manager.add_weapon(PISTOL, BULLET)
