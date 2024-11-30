extends Node2D

var player: Player = null
var hook : Sprite2D = null


var is_cast : bool = false

@export var button_id : int = 1

@export_category("Hook power")
@export var min_power : int = 50
@export var max_power : int = 150

func _ready() -> void:
	player = GameManager.get_player()
	hook = $hook/hookSprite2D
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	# lock the hook rotation
	hook.global_rotation = 0.0


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.get_button_index() == button_id and event.is_pressed():
			if !is_cast:
				# Cast the hook
				var direction =  Vector2(1,0)
				
				var hook_force = randf_range(min_power, max_power)
				
				is_cast = true
				
				hook.visible = is_cast
				
				
				
				hook.set_position(direction * hook_force)
				
			else:
				# Retract the hook
				is_cast = false
				
				hook.visible = is_cast
				
				hook.set_position(Vector2(0,0))
				
