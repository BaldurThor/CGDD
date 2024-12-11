extends Node2D
class_name Fish

var origin : Vector2
@export var speed : float = .025
@export_range(0,360,0.1,"radians_as_degrees") var angle : float = 0.0
@export var radius : int = 5


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not origin:
		origin = global_position
		
	radius *= 10


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var current_rotation : Vector2 = Vector2(cos(angle) * radius, sin(angle) * radius)
	set_position(current_rotation + origin)
	angle += speed
	set_rotation(angle+((90*PI)/180))
	if position.y >= origin.y:
		$Fish_sprite.flip_v = true
	else:
		$Fish_sprite.flip_v = false
		
