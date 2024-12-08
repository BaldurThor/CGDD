class_name WeaponManager extends Node2D
@onready var player_stats: PlayerStats = %PlayerStats
const SHOTGUN = preload("res://player/gun/gun_types/shotgun/shotgun.tres")
const BULLET = preload("res://player/gun/bullets/basic/bullet.tscn")
const FIREARM = preload("res://player/gun/firearm.tscn")
## Initialize the player with the shotgun via the manager so the player can
## have consistent logic between all weapons.
func _ready() -> void:
	add_weapon(SHOTGUN, BULLET)

func add_weapon(weapon_type: WeaponType, bullet_type: PackedScene) -> void:
	var firearm = FIREARM.instantiate()
	firearm.init(weapon_type, bullet_type, player_stats)
	#var swivel = GunSwivel.new(weapon_type, bullet_type, player_stats)
	add_child.call_deferred(firearm)
