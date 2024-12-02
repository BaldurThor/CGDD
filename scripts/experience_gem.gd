class_name ExperienceGem extends RigidBody2D

@onready var acceleration_timer: Timer = $AccelerationTimer
var experience_value: int
var tracking_speed: int = 100
var should_track: bool = false
var _player: Player


func _physics_process(delta: float) -> void:
	if should_track:
		linear_velocity = (GameManager.get_player().global_position - global_position).normalized() * tracking_speed

func start_tracking_player() -> void:
	acceleration_timer.start()
	should_track = true

func _on_acceleration_timer_timeout() -> void:
	tracking_speed += 1
