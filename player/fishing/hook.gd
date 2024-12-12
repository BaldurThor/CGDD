class_name Hook extends Area2D

var player: Player = null
var hook_sprite : Sprite2D = null
@onready var ability_selector: AbilitySelector = %AbilitySelector

# the possision of the hook when it is cast
var pos := Vector2(0,0)

var angle : float = -1
var vec : Vector2 = Vector2(0,0)

@export_category("Hook power")
@export var min_power : int = 50
@export var max_power : int = 150
@export var speed : float = 10
@export var max_dist : int = 400



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = GameManager.get_player()
	hook_sprite = $hookSprite2D
	
# this needs a better name
func _catch_catch(catch) -> void:
	if catch == null:
		return
	elif catch is Fish:
		#ability_picker
		DebugCommands.get_ability_picker()
		catch.queue_free()
	elif catch is PickupBase:
		if catch.hookable:
			catch.pickup()
	catch = null
		
func _stop_cast() -> void:
	pos = get_global_position()
	angle = -1
	
	hook_sprite.visible = false
	pos = Vector2(0,0)
	set_position(pos)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# lock the hook rotation
	global_rotation = 0.0
	
	var dir = (get_global_mouse_position() - player.global_position).normalized()
	
	# makes sure that the hook does not move with the player when cast
	if Input.is_action_pressed("fish_cast"):
		if angle == -1:
			angle = $"..".rotation
			hook_sprite.visible = true
			pos = get_global_position()
			vec = Vector2(cos(angle), sin(angle)) * speed
		
		pos += vec
		set_global_position(pos)
		
		var _tmp = pos - player.get_global_position()
		var dist = sqrt(_tmp.dot(_tmp))
		if dist > max_dist:
			Input.action_release("fish_cast")
			_stop_cast()
			
	if Input.is_action_just_released("fish_cast"):
		_stop_cast()



func _on_body_entered(body: Node2D) -> void:
	if body is RigidBody2D and angle != -1:
		_catch_catch(body)
