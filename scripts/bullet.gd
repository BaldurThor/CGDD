class_name Bullet extends RigidBody2D

## The time before the bullet automatically despawns
@export var despawn_delay: float

@onready var despawn_timer: Timer = $DespawnTimer

var direction: Vector2
var _weapon_type: WeaponType
var hit_count: int = 0

func init(weapon_type: WeaponType, bullet_direction: Vector2) -> void:
	_weapon_type = weapon_type
	direction = bullet_direction

func _ready() -> void:
	despawn_timer.wait_time = despawn_delay

func _physics_process(_delta: float) -> void:
	linear_velocity = direction.normalized() * _weapon_type.projectile_speed

func _on_body_entered(body: Node) -> void:
	if body is Enemy:
		body.take_damage(_weapon_type.damage * _weapon_type.damage_effectiveness)
		# If the bullet has pierced a certain number of times, delete it.
		if _weapon_type.pierce_count > hit_count:
			hit_count += 1
		else:
			queue_free()

func _on_despawn_timer_timeout() -> void:
	queue_free()
