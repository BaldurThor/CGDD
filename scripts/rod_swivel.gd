extends Node2D

var player: Player = null


var hook : StaticBody2D = null
var hook_sprite : Sprite2D = null
var hook_collider : CollisionShape2D

var is_cast : bool = false

@export var button_id : MouseButton = 1

@export_category("Hook power")
@export var min_power : int = 50
@export var max_power : int = 150

func _ready() -> void:
	player = GameManager.get_player()
	hook = $hook
	hook_sprite = $hook/hookSprite2D
	hook_collider = $hook/hookCollisionShape2D
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	# lock the hook rotation
	hook.global_rotation = 0.0
	hook_collider.enab


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.get_button_index() == button_id and event.is_pressed():
			if !is_cast:
				# Cast the hook
				var direction =  Vector2(1,0)
				var hook_force = randf_range(min_power, max_power)
				
				is_cast = true
				
				hook_sprite.visible = is_cast
				var col : KinematicCollision2D = hook.move_and_collide(direction * hook_force)
				
				hook_collider.is_coll
				
			else:
				# Retract the hook
				is_cast = false
				
				hook_sprite.visible = is_cast
				
				hook.set_position(Vector2(0,0))
				
