class_name PickupBase extends RigidBody2D

@onready var acceleration_timer: Timer = $AccelerationTimer
@onready var despawn_timer : Timer = $DespawnTimer
@onready var pickup_radius: Area2D = $PickupRadius

@export var base_tracking_speed: int = 150

var acceleration: int = 0
var should_track: bool = false
var _player: Player = null

func start_tracking_player() -> void:
	acceleration_timer.start()
	should_track = true

func _init() -> void:
	_player = GameManager.get_player()
	
func _ready() -> void:
	despawn_timer.timeout.connect(_on_despawn_timer_timeout)
	acceleration_timer.timeout.connect(_on_acceleration_timer_timeout)

func _physics_process(_delta: float) -> void:
	if should_track:
		linear_velocity = (_player.global_position - global_position).normalized() * get_tracking_speed()

## Override this method with whatever logic you need for the pickup.
## Remember to call super afterwards!
func pickup() -> void:
	queue_free.call_deferred()

func get_tracking_speed() -> int:
	return int((base_tracking_speed + acceleration) * _player.player_stats.item_absorb_speed_mod)

func _on_acceleration_timer_timeout() -> void:
	acceleration += 1
	
func _on_despawn_timer_timeout() -> void:
	queue_free.call_deferred()
