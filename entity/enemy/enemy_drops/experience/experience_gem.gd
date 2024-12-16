class_name ExperienceGem extends PickupBase

@onready var debug_label : Label = $debug_stuff
@onready var sprite: Sprite2D = $Sprite
@onready var glow: Sprite2D = $Glow
@onready var clump_range: Area2D = $ClumpRange

var player_stats: PlayerStats = null
var experience_value: int
var can_clump: bool = true

func _ready() -> void:
	player_stats = GameManager.get_player().player_stats
	
func start_tracking_player() -> void:
	can_clump = false
	super()

func _physics_process(_delta: float) -> void:
	debug_label.visible = Debug.enable
	if Debug.enable:
		debug_label.text = "xp value : " + str(experience_value) + "\nTime to despawn : " + str(int(despawn_timer.time_left))
	if can_clump:
		_check_clump()
	_update_glow()
	super(_delta)

func _check_clump() -> void:
	var gems = clump_range.get_overlapping_bodies()
	for gem in gems:
		if gem is ExperienceGem and !gem.should_track and gem != self:
			experience_value += gem.experience_value
			gem.queue_free()
	can_clump = false

func assign_value(value: int) -> void:
	experience_value = value

func _update_glow() -> void:
	glow.modulate = Color(0.,0.,0.,0.)
	if experience_value < 26:
		sprite.frame = 0
	elif experience_value < 51:
		sprite.frame = 1
	elif experience_value < 76:
		sprite.frame = 2
		glow.modulate = Color(0.,1.,0.,1.)
	elif experience_value < 101:
		sprite.frame = 3
		glow.modulate = Color(0.,1.,0.,1.)
	elif experience_value < 151:
		sprite.frame = 4
		glow.modulate = Color(1.,0.,0.,1.)
	elif experience_value > 150:
		sprite.frame = 5
		glow.modulate = Color(1.,0.,0.,1.)
	# glow.material.set_shader_parameter("intensity", float(experience_value))

func pickup() -> void:
	_player.experience.gain_experience.emit(experience_value, true)
	super()
