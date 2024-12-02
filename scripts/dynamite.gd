class_name Dynamite extends RigidBody2D

## The time before the bullet automatically despawns
@export var despawn_delay: float

@onready var despawn_timer: Timer = $DespawnTimer
@onready var area_2d: Area2D = $Area2D
@onready var explosion_animation: AnimationPlayer = $ExplosionAnimation

var direction: Vector2
var _weapon_type: WeaponType
var hit_count: int = 0

func init(weapon_type: WeaponType, bullet_direction: Vector2) -> void:
	_weapon_type = weapon_type
	direction = bullet_direction

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
	explosion_animation.play("explode")
	for enemy in nearby_enemies:
		if enemy is Enemy:
			enemy.take_damage(_weapon_type.damage * _weapon_type.damage_effectiveness)
