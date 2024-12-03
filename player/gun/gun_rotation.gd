class_name GunSwivel extends Node2D

func _process(_delta: float) -> void:
	var enemy = GameManager.get_enemy_manager().get_closest_enemy_to_player()
	if enemy != null:
		look_at(enemy.position)
