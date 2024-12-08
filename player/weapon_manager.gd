class_name WeaponManager extends Node2D

@onready var player_stats: PlayerStats = %PlayerStats

const FIREARM = preload("res://player/gun/firearm.tscn")

## Initialize the player with the shotgun via the manager so the player can
## have consistent logic between all weapons.
func _ready() -> void:
	var weapon = load("res://player/gun/gun_types/rifle/rifle.tres")
	#var weapon = load("res://player/gun/gun_types/dynamite/dynamite_thrower.tres")
	#var weapon = load("res://player/gun/gun_types/shotgun/shotgun.tres")
	#var weapon = load("res://player/gun/gun_types/frag_grenade/frag_grenade_thrower.tres")
	add_weapon(weapon)

func add_weapon(weapon_type: WeaponType) -> void:
	var firearm = FIREARM.instantiate()
	firearm.init(weapon_type, player_stats)
	add_child.call_deferred(firearm)
