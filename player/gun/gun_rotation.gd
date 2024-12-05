class_name GunSwivel extends Node2D

var target_prio : consts.TargetPriority

const GUN = preload("res://player/gun/gun.tscn")
func add_weapon(weapon: WeaponType, bullet_type: PackedScene, stats: PlayerStats):
	var gun = GUN.instantiate()
	target_prio = weapon.target_priority
	print(target_prio)
	gun.init(weapon, bullet_type, stats)
	add_child(gun)

func _process(_delta: float) -> void:
	var enemy = GameManager.get_enemy_manager().find_target(target_prio)
	if enemy != null:
		look_at(enemy.position)
