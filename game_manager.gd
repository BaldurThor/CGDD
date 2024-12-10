extends Node

var _player: Player = null
var _enemy_manager: EnemyManager = null
var game_timer: Timer
var lvl_up: bool = false

var world_level: int = 1
var level_transitioning: bool = false

var pause_count: int = 0
var pause_tracker: Array[Node] = []

# Global game events
signal enemy_take_damage(amount: int)
signal enemy_died
signal player_take_damage(amount: int)
signal explosion_occurred(intensity: float)
signal pickup_ability(ability: AbilityInfo)
signal new_world_level(new_level: int)

const LEVEL_COUNT: int = 4

@onready var death_scene: PackedScene = preload("res://menu/death/death.tscn")

func _ready() -> void:
	game_timer = Timer.new()
	game_timer.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(game_timer)

func start_game() -> void:
	get_tree().change_scene_to_file("res://levels/game.tscn")
	reset_pause()
	
	game_timer.stop()
	game_timer.wait_time = 1200 / 2
	game_timer.one_shot = true
	game_timer.start()
	
	world_level = 1

func _process(_delta: float) -> void:
	if game_timer.is_stopped():
		return
	
	var progress: float = 1 - game_timer.time_left / game_timer.wait_time
	var level = int(progress * LEVEL_COUNT) + 1
	if level != world_level:
		world_level = level
		new_world_level.emit(level)

func main_menu() -> void:
	get_tree().change_scene_to_file("res://menu/main/menu.tscn")
	reset_pause()

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

func get_game_root() -> Node2D:
	return _player.get_parent()

func quit() -> void:
	SaveManager.save_data()
	get_tree().quit()

func _notification(type: int) -> void:
	if type == NOTIFICATION_WM_CLOSE_REQUEST:
		quit()

func get_world_level_progress() -> float:
	var percentage = 1.0 - (game_timer.time_left / game_timer.wait_time)
	var segment = 1.0 / LEVEL_COUNT
	return fmod(percentage, segment) * LEVEL_COUNT

func set_pause(id: Node, paused: bool) -> void:
	if paused:
		pause(id)
	else:
		unpause(id)

func toggle_pause(id: Node) -> void:
	if id in pause_tracker:
		unpause(id)
	else:
		pause(id)

func pause(id: Node) -> void:
	if id in pause_tracker:
		return
	
	pause_tracker.append(id)
	get_tree().paused = true

func unpause(id: Node) -> void:
	var idx = pause_tracker.find(id)
	if idx == -1:
		return
	
	pause_tracker.remove_at(idx)
	if pause_tracker.size() == 0:
		get_tree().paused = false

func reset_pause() -> void:
	pause_tracker.clear()
	get_tree().paused = false

func is_paused() -> bool:
	return pause_tracker.size() > 0

func death(enemy: Enemy) -> void:
	get_tree().root.add_child(death_scene.instantiate())
	#get_node("/root/Game").reparent(get_node("/root/Death/Rest"))
	var fade_to_black = get_node("/root/Death/FadeToBlack")
	fade_to_black.position.x = _player.position.x - (fade_to_black.size.x / 2)
	fade_to_black.position.y = _player.position.y - (fade_to_black.size.y / 2)
	#_player.reparent(get_node("/root/Death/PlayerEnemy"))
	#enemy.enemy_base.sprite_2d.reparent(get_node("/root/Death/PlayerEnemy"))
