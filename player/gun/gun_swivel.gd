class_name GunSwivel extends Node2D

const GUN = preload("res://player/gun/gun.tscn")

var _gun: Gun

func add_weapon(weapon: WeaponType, bullet_type: PackedScene, stats: PlayerStats) -> void:
	_gun = GUN.instantiate()
	_gun.init(weapon, bullet_type, stats)
	add_child(_gun)

func _process(_delta: float) -> void:
	var enemy = _gun.target_range.current_target
	if enemy != null:
		look_at(enemy.position)
