extends Node
class_name Enemies

@export var enemy_scene: PackedScene

@export var enemy_type: EnemyType:
	set(value):
		enemy_type = value
		update_configuration_warnings()

func _on_enemy_timer_timeout() -> void:
	# Create a new instance of the Mob scene.
	var enemy = enemy_scene.instantiate()

	# Choose a random location on the SpawnPath.
	# We store the reference to the SpawnLocation node.
	var enemy_spawn_location = get_node("/root/Main/Player/SpawnPath/SpawnLocation")
	
	# And give it a random offset.
	enemy_spawn_location.progress_ratio = randf()

	enemy.initialize(enemy_spawn_location.position)

	# Spawn the mob by adding it to the Main scene.
	add_child(enemy)
