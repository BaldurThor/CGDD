class_name WeaponManager extends Node2D

@onready var player_stats: PlayerStats = %PlayerStats

const FIREARM = preload("res://player/gun/firearm.tscn")
const MELEE_WEAPON = preload("res://player/melee/melee_weapon.tscn")

## Initialize the player with the shotgun via the manager so the player can
## have consistent logic between all weapons.
func _ready() -> void:
	#var weapon = load("res://player/gun/gun_types/shotgun/shotgun.tres")
	var weapon = load("res://player/melee/metal_baseball_bat/metal_baseball_bat.tres")
	#add_weapon(weapon)
	add_melee_weapon(weapon)

func add_weapon(weapon_type: WeaponType) -> void:
	var firearm = FIREARM.instantiate()
	firearm.init(weapon_type, player_stats)
	add_child.call_deferred(firearm)

func add_melee_weapon(weapon_type: WeaponType) -> void:
	var melee = MELEE_WEAPON.instantiate()
	melee.init(weapon_type, player_stats)
	add_child.call_deferred(melee)
