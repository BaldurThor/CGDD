extends LogicNode

@export var slam_area: Area2D
@export var enemy: Enemy
@export var entity_stats: EntityStats
@export var rotation_speed: float = 1.5
@export var cooldown_time: float = 4.0
@export var windup_time: float = 3.0
@export var attack_damage: int = 20
@export var sprite_2d: Sprite2D

@onready var cooldown_timer: Timer = $CooldownTimer
@onready var windup_timer: Timer = $WindupTimer
@onready var slam_sfx: AudioStreamPlayer2D = $SlamSFX

var _player: Player = null
var _can_attack: bool = true
var _mat: ShaderMaterial = null

func _ready() -> void:
	_player = GameManager.get_player()
	cooldown_timer.wait_time = cooldown_time
	cooldown_timer.timeout.connect(func(): _can_attack = true)
	windup_timer.wait_time = windup_time
	windup_timer.timeout.connect(_slam)
	entity_stats.death.connect(_on_enemy_death)
	_mat = sprite_2d.material
	_mat.set_shader_parameter("transparency", 0)

func evaluate() -> bool:
	return _can_attack
	
func execute_logic() -> void:
	if _can_attack:
		_can_attack = false
		windup_timer.start()

func _process(delta: float) -> void:
	var dir: Vector2 = (_player.global_position - enemy.global_position).normalized()
	
	slam_area.rotation = lerp_angle(slam_area.rotation, atan2(dir.y, dir.x), delta * rotation_speed)
	
	if not windup_timer.is_stopped():
		var attack_percentage = 1 - windup_timer.time_left / windup_timer.wait_time
		_mat.set_shader_parameter("transparency", attack_percentage)
	else:
		_mat.set_shader_parameter("transparency", 0)

func _slam() -> void:
	var pitch_modification = randf_range(0.5, 2)
	slam_sfx.pitch_scale = pitch_modification
	slam_sfx.play()
	for entity in slam_area.get_overlapping_bodies():
		if entity.get_instance_id() == _player.get_instance_id():
			_player.take_damage(attack_damage, enemy)
	var mat: ShaderMaterial = sprite_2d.material
	mat.set_shader_parameter("flash", true)
	await get_tree().create_timer(0.1).timeout
	mat.set_shader_parameter("flash", false)
	cooldown_timer.start()
	var dir: Vector2 = (_player.global_position - enemy.global_position).normalized()
	slam_area.rotation = atan2(dir.y, dir.x)

func _on_enemy_death() -> void:
	windup_timer.stop()
	cooldown_timer.stop()
	slam_area.visible = false
