extends Ability

const FRAG_GRENADE = preload("res://player/gun/bullets/frag_grenade/frag_grenade.tscn")
const FRAG_GRENADE_THROWER = preload("res://player/gun/gun_types/frag_grenade/frag_grenade_thrower.tres")

func apply_effects(_player_stats: PlayerStats) -> void:
	player.weapon_manager.add_weapon(FRAG_GRENADE_THROWER, FRAG_GRENADE)
