class_name ExperienceGem extends PickupBase

@onready var debug_label : Label = $debug_stuff
@onready var sprite: Sprite2D = $Sprite
@onready var glow: Sprite2D = $Glow

var player_stats: PlayerStats = null
var experience_value: int

func _ready() -> void:
	player_stats = GameManager.get_player().player_stats

func _physics_process(_delta: float) -> void:
	debug_label.visible = Debug.enable
	if Debug.enable:
		debug_label.text = "xp value : " + str(experience_value) + "\nTime to despawn : " + str(int(despawn_timer.time_left))
	if experience_value < 11:
		sprite.frame = 0
	elif experience_value < 21:
		sprite.frame = 1
	elif experience_value < 31:
		sprite.frame = 2
		glow.material.set_shader_parameter("glow_color", Color(1.,0.,0.,1.))
	elif experience_value > 30:
		sprite.frame = 3
		glow.material.set_shader_parameter("glow_color", Color(1.,0.,0.,1.))
	if should_track:
		linear_velocity = (GameManager.get_player().global_position - global_position).normalized() * get_tracking_speed()
	glow.material.set_shader_parameter("intensity", float(experience_value))
	super(_delta)

func _on_clump_range_body_entered(body: Node2D) -> void:
	if body is ExperienceGem:
		if despawn_timer.time_left > body.despawn_timer.time_left:
			experience_value += body.experience_value
			body.queue_free()

func assign_value(value: int) -> void:
	experience_value = value
	
func pickup() -> void:
	_player.experience.gain_experience.emit(experience_value)
	super()
