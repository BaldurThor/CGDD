extends Node

var _player: Player = null
var _enemy_manager: EnemyManager = null
var _stats_man: StatsMan
var game_timer: Timer

var world_level: int = 1
var freeze_enemies: bool = false

var pause_count: int = 0
var pause_tracker: Array[Node] = []
var active_boss: Boss = null

var death: bool = false

var _time_played: int = 0
var _time_when_done: int = 0
var _endless_time_start: int = 0

var time_between_bosses_endless: int = 180
var endless: bool = false
var level_switcher_ready: bool = false
var last_time_boss_spawned_endless: int = 0
var scene_to_load: String = ""

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
signal spawn_random_boss
signal caught_fish
signal got_crit
signal made_projectile

const LOADING_SCREEN = preload("res://menu/loading_screen/loading_screen.tscn")
const LEVEL_COUNT: int = 4

func _ready() -> void:
	game_timer = Timer.new()
	game_timer.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(game_timer)
	new_world_level_active.connect(_on_new_world_level_ready)
	game_timer.timeout.connect(_on_game_timer_timeout)
	process_mode = PROCESS_MODE_ALWAYS

func _on_new_world_level_ready():
	game_timer.paused = false

func _on_game_timer_timeout():
	game_timer_over.emit()
	world_level = LEVEL_COUNT + 1
	freeze_enemies = true
	new_world_level.emit()

func add_boss(boss: Boss) -> void:
	if active_boss != null:
		active_boss.queue_free()
	
	active_boss = boss
	boss_spawned.emit(boss)

func get_active_boss() -> Boss:
	return active_boss

func start_game() -> void:
	self._time_played = 0
	self._time_when_done = 0
	reset_pause()
	
	game_timer.stop()
	game_timer.wait_time = 720
	game_timer.one_shot = true
	game_timer.start()
	
	world_level = 1
	freeze_enemies = false
	endless = false
	level_switcher_ready = false
	load_scene("res://levels/game.tscn")

func load_scene(scene_path: String) -> void:
	scene_to_load = scene_path
	get_tree().change_scene_to_packed(LOADING_SCREEN)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("toggle_fullscreen"):
		match DisplayServer.window_get_mode():
			DisplayServer.WindowMode.WINDOW_MODE_WINDOWED: DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN)
			_: DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)
	
	#self.level_switcher_ready is a debug thing!
	if self.endless and self.level_switcher_ready:
		if self.world_level != LEVEL_COUNT + 2:
			world_level = LEVEL_COUNT + 2
			freeze_enemies = true
			new_world_level.emit()
		elif ((self._endless_time_start - self._time_played) % self.time_between_bosses_endless) == 0 and self._time_played != 0 and self.last_time_boss_spawned_endless != self._time_played:
			if self.active_boss != null:
				spawn_random_boss.emit()
			self.last_time_boss_spawned_endless = self._time_played
		
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
	load_scene("res://menu/main/menu.tscn")
	reset_pause()

# Used by the player.gd script to tell the game manager where the player is.
# Allows other scripts to access the player from wherever they are.
func assign_player(player: Player):
	_player = player

func assign_stats_man(stats_man: StatsMan) -> void:
	_stats_man = stats_man

# Returns the currently assigned instance of the player. Returns null if no
# player is assigned
func get_player() -> Player:
	return _player

func get_stats_man() -> StatsMan:
	return _stats_man

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
	if not self.endless:
		var percentage = 1.0 - (game_timer.time_left / game_timer.wait_time)
		var segment = 1.0 / LEVEL_COUNT
		return fmod(percentage, segment) * LEVEL_COUNT
	else:
		return remap(self._endless_time_start - self._time_played, 0., 6000., 0., 1.)

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
	self.endless = true
	game_timer.stop()
	freeze_enemies = false
	self.get_player().freeze_player = false
	self._endless_time_start = self._time_played

func get_time_left() -> int:
	if not self.endless:
		return self.game_timer.time_left
	else:
		return self._time_played - self._endless_time_start

func start_endless_mode() -> void:
	_time_played = 0
	_time_when_done = 0
	reset_pause()
	
	world_level = 5
	freeze_enemies = false
	endless = true
	load_scene("res://levels/game.tscn")
