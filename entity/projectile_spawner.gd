@tool
@icon("res://entity/bosses/projectile_spawner_icon.svg")
class_name ProjectileSpawner extends Node2D

@export var autostart: bool = false

@export var spawn_waves: int = 1:
	set(value):
		spawn_waves = value
		queue_redraw()

@export var time_between_waves: float = 0.5:
	set(value):
		time_between_waves = value
		queue_redraw()

@export var offset_between_waves: float = 0.1:
	set(value):
		offset_between_waves = value
		queue_redraw()

@export var wave_distance_offset: float = 0.0:
	set(value):
		wave_distance_offset = value
		queue_redraw()

@export var minimum_range: float = 0.0:
	set(value):
		minimum_range = value
		queue_redraw()

@export var projectile_count: int = 10:
	set(value):
		projectile_count = value
		queue_redraw()

@export var initial_velocity: float = 50.0:
	set(value):
		initial_velocity = value
		queue_redraw()

@export var final_velocity: float = 50.0:
	set(value):
		final_velocity = value
		queue_redraw()

@export var randomize_shift: float = 0.0:
	set(value):
		randomize_shift = value
		queue_redraw()

@export var randomize_dist: float = 0.0:
	set(value):
		randomize_dist = value
		queue_redraw()

@export var lifetime_multiplier: float = 1.0:
	set(value):
		lifetime_multiplier = value
		queue_redraw()

@export var projectile_to_spawn: PackedScene
@export var enemy: Enemy
@export var spawn_sfx: AudioStream
@export var sound_volume_db: float
@export var screenshake_amount: float = 0.0

var audio_stream_player: AudioStreamPlayer2D
var running: bool = true
var timer: Timer = null

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	audio_stream_player = AudioStreamPlayer2D.new()
	audio_stream_player.stream = spawn_sfx
	add_child(audio_stream_player)
	
	timer = Timer.new()
	timer.wait_time = time_between_waves
	timer.one_shot = true
	timer.process_mode = Node.PROCESS_MODE_PAUSABLE
	
	if autostart:
		spawn()

func spawn() -> void:
	for i in range(spawn_waves):
		_spawn_wave(i)
		await get_tree().create_timer(time_between_waves).timeout

func _spawn_wave(wave: int):
	audio_stream_player.play()
	audio_stream_player.volume_db = sound_volume_db
	GameManager.get_player().camera.add_trauma(screenshake_amount)
	var spawn_positions = _get_projectile_spawn_positions(wave * offset_between_waves, wave)
	for spawn_position in spawn_positions:
		var dir = spawn_position.normalized()
		_spawn_single_projectile(spawn_position, dir)

func _spawn_single_projectile(pos: Vector2, dir: Vector2) -> void:
	var projectile = projectile_to_spawn.instantiate()
	projectile.init(
		dir,
		enemy,
		spawn_waves * time_between_waves * lifetime_multiplier,
		initial_velocity,
		final_velocity
	)
	GameManager.get_game_root().add_child.call_deferred(projectile)
	projectile.position = global_position + pos

func _draw() -> void:
	if Engine.is_editor_hint():
		draw_circle(Vector2.ZERO, minimum_range, Color.RED, false)
		
		for i in range(spawn_waves):
			var spawn_positions = _get_projectile_spawn_positions(i * offset_between_waves, i)
			var wave_progress = float(i) / spawn_waves
			for spawn_position in spawn_positions:
				var dir = spawn_position.normalized()
				var velocity = lerpf(initial_velocity, final_velocity, wave_progress)
				var pos_offset = i * dir * time_between_waves * velocity * lifetime_multiplier
				draw_circle(spawn_position + pos_offset, 10.0, Color.BLUE, false)
				draw_line(spawn_position + pos_offset, spawn_position + pos_offset + dir * velocity, Color.GREEN)

func _get_projectile_spawn_positions(offset: float, wave: int) -> Array[Vector2]:
	var positions: Array[Vector2] = []
	for i in range(projectile_count):
		positions.append(_get_projectile_spawn_position(i, offset, wave))
	return positions

func _get_projectile_spawn_position(idx: int, offset: float, wave: int) -> Vector2:
	var theta = 2 * PI * (float(idx) / projectile_count) + 2 * PI * offset
	var offset_max = ((2 * PI) / spawn_waves) * randomize_shift
	var final = lerpf(theta, theta + offset_max, randf())
	var dir = Vector2(cos(final), sin(final))
	var dist_randomize_offset = wave_distance_offset * randomize_dist * randf()
	return dir * minimum_range + wave * wave_distance_offset * dir + dir * dist_randomize_offset
