class_name Player extends CharacterBody2D

@onready var player_stats: PlayerStats = %PlayerStats
@onready var pick_up_sound_effect: AudioStreamPlayer2D = $PickUpSoundEffect
@onready var sprite_2d: Sprite2D = $Sprite2D

@export var death_screen: PackedScene

func _init() -> void:
	# Make sure GameManager knows about this player instance.
	# Called in _init() instead of _ready() to make sure it's
	# properly assigned for other scripts to access.
	GameManager.assign_player(self)

func _physics_process(_delta: float) -> void:
	var x_direction := Input.get_axis("move_left", "move_right")
	var y_direction := Input.get_axis("move_up", "move_down")
	var direction := Vector2(x_direction, y_direction).normalized()
	
	if x_direction != 0:
		sprite_2d.flip_h = x_direction < 0
	
	velocity = direction * player_stats.movement_speed
	
	move_and_slide()

func take_damage(amount: int) -> void:
	if player_stats.is_invincible:
		return
	player_stats.deal_damage(amount)


func _on_player_stats_death() -> void:
	get_tree().paused = true
	self.add_child(death_screen.instantiate())
