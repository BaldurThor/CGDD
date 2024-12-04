class_name FragGrenade extends RigidBody2D

## The time before the bullet automatically despawns
@export var despawn_delay: float
@export var shrapnel_type: PackedScene

@onready var despawn_timer: Timer = $DespawnTimer
@onready var area_2d: Area2D = $Area2D
@onready var explosion_animation: AnimationPlayer = $ExplosionAnimation
@onready var explosion_sound_effect: AudioStreamPlayer2D = $ExplosionSoundEffect

var direction: Vector2
var _weapon_type: WeaponType
var hit_count: int = 0
signal release_shrapnel

func init(weapon_type: WeaponType, bullet_direction: Vector2) -> void:
	_weapon_type = weapon_type
	direction = bullet_direction
	release_shrapnel.connect(_release_shrapnel)

func _ready() -> void:
	despawn_timer.wait_time = despawn_delay
	despawn_timer.timeout.connect(_explode)

func _physics_process(_delta: float) -> void:
	linear_velocity = direction.normalized() * _weapon_type.projectile_speed

func _on_body_entered(body: Node) -> void:
	if body is Enemy:
		direction = Vector2.ZERO

func _on_despawn_timer_timeout() -> void:
	_explode()

func _explode() -> void:
	var nearby_enemies = area_2d.get_overlapping_bodies()
	# Randomly pitch the sound effect up/down to add variety.
	explosion_sound_effect.pitch_scale = randf_range(0.8, 1.2)
	explosion_animation.play("explode")
	for enemy in nearby_enemies:
		if enemy is Enemy:
			enemy.take_damage(_weapon_type.damage * _weapon_type.damage_effectiveness)
	release_shrapnel.emit()
	
func _release_shrapnel() -> void:
	for i in range(_weapon_type.projectile_count):
		var shrapnel = shrapnel_type.instantiate()
		# Select a random angle between 0° and 360° (as radians) to launch the shrapnel projectile in.
		# NOTE: deg_to_rad assumes the value received is in radians, not degrees.
		var shrapnel_orientation = global_position.normalized().rotated(deg_to_rad(randi_range(0, 360)))
		shrapnel.init(_weapon_type, shrapnel_orientation)
		get_tree().root.add_child(shrapnel)
		shrapnel.position = global_position
