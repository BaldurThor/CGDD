extends Ability

func apply_effects(_player_stats: PlayerStats) -> void:
	var weapon = load("res://player/weapons/gun/gun_types/shotgun/shotgun.tres")
	player.weapon_manager.add_weapon(weapon)
