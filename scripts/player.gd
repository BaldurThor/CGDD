class_name Player extends CharacterBody2D

# how many seconds you are invincible after being hit

@onready var pick_up_sound_effect: AudioStreamPlayer2D = $PickUpSoundEffect
@onready var player_health: EntityHealth = $PlayerHealth
@onready var player_stats: Node = $PlayerStats

func _init() -> void:
	# Make sure GameManager knows about this player instance.
	# Called in _init() instead of _ready() to make sure it's
	# properly assigned for other scripts to access.
	GameManager.assign_player(self)

func _input(event: InputEvent) -> void:
	# DEBUG: Allows you to press escape to quickly close the game
	if event is InputEventKey and event.keycode == KEY_ESCAPE:
		get_tree().quit()

func _physics_process(_delta: float) -> void:
	var x_direction := Input.get_axis("move_left", "move_right")
	var y_direction := Input.get_axis("move_up", "move_down")
	var direction := Vector2(x_direction, y_direction).normalized()
	
	velocity = direction * player_stats.speed
	
	move_and_slide()

func take_damage(amount: int) -> void:
	player_health.deal_damage(amount)

func gain_experience(amount: int) -> void:
	# TODO: Make the pitch based on % progress to the next level on a scale of 0.5 - 2.0
	var pitch: float = randf_range(0.5, 2.0)
	pick_up_sound_effect.pitch_scale = pitch
	pick_up_sound_effect.play()
