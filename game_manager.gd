extends Node

var _player: Player = null
var _enemy_manager: EnemyManager = null
var game_timer: Timer
var lvl_up: bool = false

var world_level: int = 1

# Global game events
signal enemy_take_damage(amount: int)
signal player_take_damage(amount: int)
signal explosion_occurred(intensity: float)
signal pickup_ability(ability: AbilityInfo)
signal new_world_level(new_level: int)

const LEVEL_COUNT: int = 4

func _init() -> void:
	reset_timer()

func reset_timer() -> void:
	if game_timer != null:
		var main = get_node("/root/Main")
		main.remove_child(game_timer)
	game_timer = Timer.new()
	game_timer.wait_time = 1200 / 4
	game_timer.one_shot = true
	
func reset_tree() -> void:
	get_tree().paused = false
	var main = get_node("/root/Main")
	var children = main.get_children()
	for child in children:
		if child == game_timer:
			continue
		else:
			child.queue_free()
			main.remove_child(child)
	
	
func start_game(run: PackedScene) -> void:
	reset_tree()
	reset_timer()
	
	var main = get_node("/root/Main")
	main.add_child(run.instantiate())
	main.add_child(game_timer)
	game_timer.start()

func _process(_delta: float) -> void:
	if game_timer == null or game_timer.is_stopped():
		return
	
	
	var progress: float = 1 - game_timer.time_left / game_timer.wait_time
	var level = int(progress * LEVEL_COUNT) + 1
	if level != world_level:
		world_level = level
		new_world_level.emit(level)

func main_menu(menu: PackedScene) -> void:
	reset_tree()
	var main = get_node("/root/Main")
	main.add_child(menu.instantiate())


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

func quit() -> void:
	SaveManager.save_data()
	get_tree().quit()

func _notification(type: int) -> void:
	if type == NOTIFICATION_WM_CLOSE_REQUEST:
		quit()
