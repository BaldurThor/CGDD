class_name WeaponManager extends Node2D

@onready var player_stats: PlayerStats = %PlayerStats

func add_weapon(weapon_type: WeaponType, bullet_type: PackedScene):
	var swivel = GunSwivel.new()
	swivel.add_weapon(weapon_type, bullet_type, player_stats)
	add_child(swivel)
