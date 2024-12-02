class_name Enemies extends Node

var player: Player

@export var enemy_scene: PackedScene
@export var enemy_types: Array[EnemyType] = []
@export var spawn_radius: float = 300

@onready var enemies: Node = $Enemies

func _on_enemy_timer_timeout() -> void:
	if player == null:
		player = GameManager.get_player()
	
	var enemy_type = enemy_types.pick_random()
	
	# Create a new instance of the Mob scene.
	var enemy = enemy_scene.instantiate()

	# Choose a random spawn location around the player in a circle
	var spawn_theta = randf_range(0, 2 * PI)
	var spawn_location = Vector2(cos(spawn_theta), sin(spawn_theta)) * spawn_radius + player.global_position
	
	enemy.initialize(spawn_location, enemy_type)
	
	# Spawn the mob by adding it to the Main scene.
	enemies.add_child(enemy)

func get_closest_enemy_to_player():
	if player == null:
		player = GameManager.get_player()
	
	var all_enemies = enemies.get_children()
	var closest = null
	for enemy in all_enemies:
		if closest == null:
			closest = enemy
		elif player.position.distance_to(closest.position) > player.position.distance_to(enemy.position):
			closest = enemy
	return closest
