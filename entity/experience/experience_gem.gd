class_name ExperienceGem extends RigidBody2D

@onready var acceleration_timer: Timer = $AccelerationTimer
@onready var despawn_timer : Timer = $DespawnTimer
@onready var debug_lable : Label = $debug_stuff
@onready var sprite: Sprite2D = $Sprite
@onready var experience_pickup_radius: Area2D = $ExperiencePickupRadius

var player_stats: PlayerStats = null
var experience_value: int
var base_tracking_speed: int = 100
var should_track: bool = false
var rotation_speed: float = 0.0
var acceleration: int = 0

func _ready() -> void:
	rotation_speed = randf_range(1.0, 2.0)
	player_stats = GameManager.get_player().player_stats

func _physics_process(delta: float) -> void:
	rotate(delta * rotation_speed)
	debug_lable.visible = Debug.enable
	if Debug.enable:
		debug_lable.text = "xp value : " + str(experience_value) + "\nTime to despawn : " + str(int(despawn_timer.time_left))
	var scale_val: float = 1 + experience_value/4
	sprite.scale = Vector2.ONE * scale_val
	if should_track:
		linear_velocity = (GameManager.get_player().global_position - global_position).normalized() * get_tracking_speed()

func get_tracking_speed() -> int:
	return (base_tracking_speed + acceleration) * player_stats.experience_orb_absorb_speed_mod

func start_tracking_player() -> void:
	acceleration_timer.start()
	should_track = true

func _on_acceleration_timer_timeout() -> void:
	acceleration += 1
	
func _on_despawn_timer_timeout() -> void:
	queue_free()

func _on_clump_range_body_entered(body: Node2D) -> void:
	if body is ExperienceGem:
		if despawn_timer.time_left > body.despawn_timer.time_left:
			experience_value += body.experience_value
			body.queue_free()

func _on_experience_pickup_radius_body_entered(_body: Node2D) -> void:
	pass
	#start_tracking_player()
