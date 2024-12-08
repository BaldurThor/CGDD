extends Ability


func apply_effects(_player_stats: PlayerStats) -> void:
	var weapon = load("res://player/gun/gun_types/dynamite/dynamite_thrower.tres")
	player.weapon_manager.add_weapon(weapon)
