extends CharacterBody2D
class_name Player

const SPEED = 300.0

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
	
	velocity = direction * SPEED # TODO: add delta to the calculation!
	
	move_and_slide()
