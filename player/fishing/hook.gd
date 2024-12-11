class_name hook extends StaticBody2D

var player: Player = null
var hook_sprite : Sprite2D = null
var first : bool = false
@onready var ability_picker: AbilityPicker = %AbilityPicker

# the possision of the hook when it is cast
var pos := Vector2(0,0)

var is_cast : bool = false
var catch : RigidBody2D = null

@export var button_id : MouseButton = 1

@export_category("Hook power")
@export var min_power : int = 50
@export var max_power : int = 150
@export var speed : float = 2.5



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = GameManager.get_player()
	hook_sprite = $hookSprite2D
	
# this needs a better name
func _catch_catch() -> void:
	if catch == null:
		return
	elif catch is Fish:
		#ability_picker
		DebugCommands.get_ability_picker()
		catch.queue_free()
	elif catch is ExperienceGem:
		GameManager.get_player().experience.gain_experience.emit(catch.experience_value)
		catch.queue_free()
	catch = null
		
func _stop_cast() -> void:
	# do not question this code
	if not first:
		first = true
		return
	pos = get_global_position()
	is_cast = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# lock the hook rotation
	global_rotation = 0.0
	
	var _tmp  = get_global_mouse_position() - player.global_position
	var dir = _tmp.normalized()
	var dist = sqrt(_tmp.dot(_tmp))
	
	# makes sure that the hook does not move with the player when cast
	if Input.is_action_pressed("fish_cast") and not is_cast:
		hook_sprite.visible = true
		var col : KinematicCollision2D = move_and_collide(dir*speed)
		
		if col:
			catch = col.get_collider()
			Input.action_release("fish_cast")
			_stop_cast()
			
	if Input.is_action_just_released("fish_cast"):
		_stop_cast()
		
	if Input.is_action_just_pressed("fish_hook"):
		if not is_cast:
			return
		_catch_catch()
		is_cast = false
		hook_sprite.visible = false
		pos = Vector2(0,0)
		set_position(pos)

	
	if is_cast:
		set_global_position(pos)
		
