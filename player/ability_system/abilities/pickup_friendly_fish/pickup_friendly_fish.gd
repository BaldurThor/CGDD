extends Ability


func apply_effects(_player_stats: PlayerStats) -> void:
	var weapon = load("res://player/orbital_melee/friendly_fish/friendly_fish.tres")
	player.weapon_manager.add_orbital_melee_weapon(weapon)
