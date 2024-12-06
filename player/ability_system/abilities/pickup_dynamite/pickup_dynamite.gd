extends Ability

const DYNAMITE_THROWER = preload("res://player/gun/gun_types/dynamite/dynamite_thrower.tres")
const DYNAMITE = preload("res://player/gun/bullets/dynamite/dynamite.tscn")

func apply_effects(_player_stats: PlayerStats) -> void:
	player.weapon_manager.add_weapon(DYNAMITE_THROWER, DYNAMITE)
