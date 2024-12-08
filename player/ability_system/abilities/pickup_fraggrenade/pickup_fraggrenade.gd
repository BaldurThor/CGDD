extends Ability


func apply_effects(_player_stats: PlayerStats) -> void:
	var weapon = load("res://player/gun/gun_types/frag_grenade/frag_grenade_thrower.tres")
	player.weapon_manager.add_weapon(weapon)
