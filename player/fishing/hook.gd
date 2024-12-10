class_name hook extends StaticBody2D

var player: Player = null
var hook_sprite : Sprite2D = null
@onready var ability_picker: AbilityPicker = %AbilityPicker

# the possision of the hook when it is cast
var pos := Vector2(0,0)

var is_cast : bool = false

@export var button_id : MouseButton = 1

@export_category("Hook power")
@export var min_power : int = 50
@export var max_power : int = 150


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = GameManager.get_player()
	hook_sprite = $hookSprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# lock the hook rotation
	global_rotation = 0.0
	
	# makes sure that the hook does not move with the player when cast
	if is_cast:
		set_global_position(pos)


func _input(event: InputEvent) -> void:
	# check if a mouse button was pressed
	if event is InputEventMouseButton:
		# check if it is the button we want and that it was pressed down
		if event.get_button_index() == button_id and event.is_pressed():
			if !is_cast:
				# Cast the hook
				var direction = Vector2(1,0).rotated($"..".rotation)
				# TODO need to make something better for this as there is no control over how far yo cast the hook
				var hook_force = (min_power + max_power) / 2
				
				is_cast = true
				
				hook_sprite.visible = is_cast
				var col : KinematicCollision2D = move_and_collide(direction * hook_force)
				pos = get_global_position()

				if col:
					var col_obj : RigidBody2D = col.get_collider()
					if col_obj is Fish:
						#ability_picker
						DebugCommands.get_ability_picker()
						col_obj.queue_free()
					elif col_obj is ExperienceGem:
						GameManager.get_player().experience.gain_experience.emit(col_obj.experience_value)
						col_obj.queue_free()
					
				
				
			else:
				# Retract the hook
				is_cast = false
				
				hook_sprite.visible = is_cast
				
				set_position(Vector2(0,0))
				pos = Vector2(0,0)
				
