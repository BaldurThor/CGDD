extends Ability


func apply_effects(_player_stats: PlayerStats) -> void:
	var weapon = load("res://player/melee/metal_baseball_bat/metal_baseball_bat.tres")
	player.weapon_manager.add_melee_weapon(weapon)
