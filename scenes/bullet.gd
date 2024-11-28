extends RigidBody2D
class_name Bullet

@export var despawn_delay: float

@onready var despawn_timer: Timer = $DespawnTimer

var damage: int
var speed: float
var direction: Vector2

func init(damage: int, speed: float, direction: Vector2) -> void:
	self.damage = damage
	self.speed = speed
	self.direction = direction
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	despawn_timer.wait_time = despawn_delay

func _physics_process(delta: float) -> void:
	linear_velocity = direction.normalized() * speed
	#move_and_collide((destination - global_position).normalized() * speed)

func _on_body_entered(body: Node) -> void:
	if body is Enemy:
		body.queue_free()
		queue_free()

func _on_despawn_timer_timeout() -> void:
	queue_free() # Replace with function body.
