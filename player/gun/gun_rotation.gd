class_name GunSwivel extends Node2D

const GUN = preload("res://player/gun/gun.tscn")

func add_weapon(weapon: WeaponType, bullet_type: PackedScene, stats: PlayerStats):
	var gun = GUN.instantiate()
	gun.init(weapon, bullet_type, stats)
	add_child(gun)

func _process(_delta: float) -> void:
	var enemy = GameManager.get_enemy_manager().get_closest_enemy_to_player()
	if enemy != null:
		look_at(enemy.position)
