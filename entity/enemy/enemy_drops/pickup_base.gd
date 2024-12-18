class_name PickupBase extends RigidBody2D

@onready var acceleration_timer: Timer = $AccelerationTimer
@onready var despawn_timer : Timer = $DespawnTimer
@onready var pickup_radius: Area2D = $PickupRadius

@export var can_track_player: bool = true
@export var base_tracking_speed: int = 150
@export var acceleration_per_tick: int = 2
@export var hookable : bool = true
@export var should_despawn: bool = true
@export var should_accelerate: bool = true

var acceleration: int = 0
var should_track: bool = false
var _player: Player = null

func start_tracking_player() -> void:
	if !can_track_player:
		return
	acceleration_timer.start()
	should_track = true

func _init() -> void:
	_player = GameManager.get_player()
	
func _ready() -> void:
	if should_despawn:
		despawn_timer.timeout.connect(_on_despawn_timer_timeout)
	if should_accelerate:
		acceleration_timer.timeout.connect(_on_acceleration_timer_timeout)

func _physics_process(_delta: float) -> void:
	if should_track:
		linear_velocity = (_player.global_position - global_position).normalized() * get_tracking_speed()

## Override this method with whatever logic you need for the pickup.
## Remember to call super afterwards!
func pickup() -> void:
	queue_free.call_deferred()

func get_tracking_speed() -> int:
	return int((base_tracking_speed + acceleration))

func _on_acceleration_timer_timeout() -> void:
	acceleration += acceleration_per_tick
	
func _on_despawn_timer_timeout() -> void:
	queue_free.call_deferred()
