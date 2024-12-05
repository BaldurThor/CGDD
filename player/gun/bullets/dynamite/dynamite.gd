class_name Dynamite extends RigidBody2D

## The time before the bullet automatically despawns
@export var despawn_delay: float

@onready var despawn_timer: Timer = $DespawnTimer
@onready var area_2d: Area2D = $Area2D
@onready var explosion_animation: AnimationPlayer = $ExplosionAnimation
@onready var explosion_sound_effect: AudioStreamPlayer2D = $ExplosionSoundEffect
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D

var direction: Vector2
var _weapon_type: WeaponType
var _player_stats: PlayerStats
var hit_count: int = 0

func init(weapon_type: WeaponType, player_stats: PlayerStats, bullet_direction: Vector2) -> void:
	_weapon_type = weapon_type
	_player_stats = player_stats
	direction = bullet_direction

func _ready() -> void:
	despawn_timer.wait_time = despawn_delay
	despawn_timer.timeout.connect(_explode)
	gpu_particles_2d.emitting = false

func _physics_process(_delta: float) -> void:
	linear_velocity = direction.normalized() * _weapon_type.projectile_speed

func _on_body_entered(body: Node) -> void:
	if body is Enemy:
		direction = Vector2.ZERO

func _on_despawn_timer_timeout() -> void:
	GameManager.explosion_occurred.emit()
	_explode()

func _explode() -> void:
	var nearby_enemies = area_2d.get_overlapping_bodies()
	# Randomly pitch the sound effect up/down to add variety.
	explosion_sound_effect.pitch_scale = randf_range(0.8, 1.2)
	explosion_animation.play("explode")
	for enemy in nearby_enemies:
		if enemy is Enemy:
			enemy.take_damage(_weapon_type.damage * _weapon_type.damage_effectiveness)
