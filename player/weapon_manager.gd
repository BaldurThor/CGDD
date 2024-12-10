class_name WeaponManager extends Node2D

@onready var player_stats: PlayerStats = %PlayerStats

const FIREARM = preload("res://player/gun/firearm.tscn")
const MELEE_WEAPON = preload("res://player/melee/melee_weapon.tscn")
const ORBITAL_MELEE_WEAPON = preload("res://player/orbital_melee/orbital_melee_weapon.tscn")

func add_weapon(weapon_type: WeaponType) -> void:
	var firearm = FIREARM.instantiate()
	firearm.init(weapon_type, player_stats)
	add_child.call_deferred(firearm)

func add_melee_weapon(weapon_type: WeaponType) -> void:
	var melee = MELEE_WEAPON.instantiate()
	melee.init(weapon_type, player_stats)
	add_child.call_deferred(melee)

func add_orbital_melee_weapon(weapon_type: WeaponType) -> void:
	var orbital_melee = ORBITAL_MELEE_WEAPON.instantiate()
	orbital_melee.init(weapon_type, player_stats)
	add_child.call_deferred(orbital_melee)
