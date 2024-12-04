extends Node

var _player: Player = null
var _enemy_manager: EnemyManager = null
var game_timer: Timer

func _init() -> void:
	reset_timer()

func reset_timer() -> void:
	if game_timer != null:
		var main = get_node("/root/Main")
		main.remove_child(game_timer)
	game_timer = Timer.new()
	game_timer.wait_time = 1200
	
func start_game(run: PackedScene) -> void:
	var main = get_node("/root/Main")
	main.remove_child(get_node("/root/Main/Menu"))
	main.add_child(run.instantiate())
	main.add_child(game_timer)
	game_timer.start()

# Used by the player.gd script to tell the game manager where the player is.
# Allows other scripts to access the player from wherever they are.
func assign_player(player: Player):
	_player = player

# Returns the currently assigned instance of the player. Returns null if no
# player is assigned
func get_player() -> Player:
	return _player

func assign_enemy_manager(enemy_manager: EnemyManager) -> void:
	_enemy_manager = enemy_manager

func get_enemy_manager() -> EnemyManager:
	return _enemy_manager
