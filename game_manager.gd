extends Node

var _player: Player = null
var _enemy_manager: EnemyManager = null
var game_timer: Timer

var world_level: int = 1
var freeze_enemies: bool = false

var pause_count: int = 0
var pause_tracker: Array[Node] = []
var active_boss: Boss = null

var death: bool = false

var endless: bool = false

# Global game events
signal enemy_take_damage(amount: int)
signal enemy_died
signal game_timer_over
signal game_win
signal player_take_damage(amount: int)
signal explosion_occurred(intensity: float)
signal pickup_ability(ability: AbilityInfo)
# when the level transision starts
signal new_world_level
# when the level transision is over
signal new_world_level_active
signal boss_spawned(boss: Boss)
signal boss_killed(boss: Boss)

const LEVEL_COUNT: int = 4

func _ready() -> void:
	game_timer = Timer.new()
	game_timer.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(game_timer)
	new_world_level_active.connect(_on_new_world_level_ready)
	game_timer.timeout.connect(_on_game_timer_timeout)

func _on_new_world_level_ready():
	game_timer.paused = false

func _on_game_timer_timeout():
	game_timer_over.emit()

func add_boss(boss: Boss) -> void:
	if active_boss != null:
		active_boss.queue_free()
	
	active_boss = boss
	boss_spawned.emit(boss)

func get_active_boss() -> Boss:
	return active_boss

func start_game() -> void:
	get_tree().change_scene_to_file("res://levels/game.tscn")
	reset_pause()
	
	game_timer.stop()
	game_timer.wait_time = 720
	game_timer.one_shot = true
	game_timer.start()
	
	world_level = 1
	freeze_enemies = false

func _process(_delta: float) -> void:
	if game_timer.is_stopped():
		return
	
	var progress: float = 1 - game_timer.time_left / game_timer.wait_time
	var level = int(progress * LEVEL_COUNT) + 1
	if level != world_level:
		world_level = level
		freeze_enemies = true
		new_world_level.emit()
		game_timer.paused = true

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
		SaveManager.save_data()

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

func endless_mode() -> void:
	self.freeze_enemies = false
	self.get_player().freeze_player = false
	self.endless = true

func get_time_left() -> int:
	if not self.endless:
		return self.game_timer.time_left
	else:
		return 0 # return einars new fancy timer
