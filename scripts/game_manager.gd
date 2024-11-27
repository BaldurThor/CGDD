extends Node

var _player: Player = null

@export var enemy_scene: PackedScene

@export var enemy_type: EnemyType:
	set(value):
		enemy_type = value
		update_configuration_warnings()

# Used by the player.gd script to tell the game manager where the player is.
# Allows other scripts to access the player from wherever they are.
func assign_player(player: Player):
	_player = player

# Returns the currently assigned instance of the player. Returns null if no
# player is assigned
func get_player() -> Player:
	return _player


func _on_enemy_timer_timeout() -> void:
	# Create a new instance of the Mob scene.
	var enemy = enemy_scene.instantiate()

	# Choose a random location on the SpawnPath.
	# We store the reference to the SpawnLocation node.
	var enemy_spawn_location = get_node("Player/SpawnPath/SpawnLocation")
	# And give it a random offset.
	enemy_spawn_location.progress_ratio = randf()

	enemy.initialize(enemy_spawn_location.position)

	# Spawn the mob by adding it to the Main scene.
	add_child(enemy)
