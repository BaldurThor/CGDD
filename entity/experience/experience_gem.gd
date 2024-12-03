class_name ExperienceGem extends RigidBody2D

@onready var acceleration_timer: Timer = $AccelerationTimer
@onready var despawn_timer : Timer = $DespawnTimer
@onready var debug_lable : Label = $debug_stuff

var experience_value: int
var tracking_speed: int = 100
var should_track: bool = false



func _physics_process(delta: float) -> void:
	debug_lable.visible = Debug.enable
	if Debug.enable:
		debug_lable.text = "xp valure : " + str(experience_value) + "\nTime to despawn : " + str(int(despawn_timer.time_left))
	var scale_val : float = 1 + experience_value/4
	$Sprite.scale = Vector2(scale_val, scale_val)
	if should_track:
		linear_velocity = (GameManager.get_player().global_position - global_position).normalized() * tracking_speed

func start_tracking_player() -> void:
	acceleration_timer.start()
	should_track = true

func _on_acceleration_timer_timeout() -> void:
	tracking_speed += 1
	
func _on_despawn_timer_timeout() -> void:
	queue_free()

func _on_clump_range_body_entered(body: Node2D) -> void:
	if body is ExperienceGem:
		if experience_value == body.experience_value:
			if despawn_timer.time_left > body.despawn_timer.time_left:
				experience_value += body.experience_value
				body.queue_free()
		elif experience_value > body.experience_value:
			experience_value += body.experience_value
			body.queue_free()
	
