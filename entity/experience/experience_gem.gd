class_name ExperienceGem extends RigidBody2D

@onready var acceleration_timer: Timer = $AccelerationTimer
@onready var despawn_timer : Timer = $DespawnTimer
@onready var debug_lable : Label = $debug_stuff
@onready var sprite: Sprite2D = $Sprite
@onready var experience_pickup_radius: Area2D = $ExperiencePickupRadius

var experience_value: int
var tracking_speed: int = 100
var should_track: bool = false
var rotation_speed: float = 0.0

func _ready() -> void:
	rotation_speed = randf_range(1.0, 2.0)

func _physics_process(delta: float) -> void:
	rotate(delta * rotation_speed)
	debug_lable.visible = Debug.enable
	if Debug.enable:
		debug_lable.text = "xp value : " + str(experience_value) + "\nTime to despawn : " + str(int(despawn_timer.time_left))
	var scale_val: float = 1 + experience_value/4
	sprite.scale = Vector2.ONE * scale_val
	#experience_pickup_radius.scale = Vector2.ONE * scale_val
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

func _on_experience_pickup_radius_body_entered(_body: Node2D) -> void:
	pass
	#start_tracking_player()
