class_name Player extends CharacterBody2D

# how many seconds you are invincible after being hit


@export_category("Stats")
@export var speed: float = 300.0 # logarithmic scale
@export var damage: int = 10 # linear
@export var health: int = 10 # linear
@export_range(0, 0.75, 0.01) var dodge_chance: float = 0.0 # linear
@export_range(0, 3, 0.01) var crit_chance: float = 0.0 # linear
@export_range(0, 2, 1, "or_greater") var extra_projectiles = 0 # linear addative
@export var attack_speed: int = 1

@onready var pick_up_sound_effect: AudioStreamPlayer2D = $PickUpSoundEffect
@onready var entity_health: EntityHealth = $EntityHealth

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
	
	velocity = direction * speed
	
	move_and_slide()

func take_damage(amount: int) -> void:
	entity_health.deal_damage(amount)


func _on_pickup_radius_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
