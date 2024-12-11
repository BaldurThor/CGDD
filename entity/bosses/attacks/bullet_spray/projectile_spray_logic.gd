extends LogicNode

@onready var attack_timer: Timer = $AttackTimer
@onready var fire_sound: AudioStreamPlayer2D = $FireSound
@onready var cooldown_timer: Timer = $CooldownTimer
@onready var burst_length: Timer = $BurstLength

@export var enemy: Enemy
@export var projectile_scene: PackedScene
@export var projectile_lifetime: float = 10.0
@export var projectile_initial_velocity: float = 100.0
@export var projectile_final_velocity: float = 100.0
@export var initial_distance: float = 50.0
@export var spread: float = 0.1

var _cooldown: bool = false
var _can_attack: bool = false

func evaluate() -> bool:
	return _can_attack and not _cooldown

func execute_logic():
	_can_attack = false
	fire_sound.play()
	var dir = (GameManager.get_player().global_position - enemy.global_position).normalized()
	dir = dir.rotated(randf() * spread * PI * 2)
	var projectile = projectile_scene.instantiate()
	projectile.init(
		dir,
		enemy,
		projectile_lifetime,
		projectile_initial_velocity,
		projectile_final_velocity
	)
	GameManager.get_game_root().add_child.call_deferred(projectile)
	projectile.position = enemy.global_position + dir * initial_distance
	attack_timer.start()

func _on_attack_timer_timeout() -> void:
	_can_attack = true


func _on_burst_length_timeout() -> void:
	_cooldown = true
	cooldown_timer.start()

func _on_cooldown_timer_timeout() -> void:
	_cooldown = false
	attack_timer.start()
