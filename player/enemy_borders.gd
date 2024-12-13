#@tool
extends Node2D

@export_group("Spawn Range")
#"""
@export var radius_max: int = 1500
@export var radius_min_start: int = 450
@export var radius_min_end: int = 700

@onready var player: Player = $".."


"""
@export var radius_max: int:
	set(value):
		radius_max = value
		queue_redraw()
		
@export var radius_min_start: int:
	set(value):
		radius_min_start = value
		queue_redraw()

@export var radius_min_end: int:
	set(value):
		radius_min_end = value
		queue_redraw()
"""

var radius: int = radius_min_start

func get_new_pos(dir_vec : Vector2) -> Vector2:
	var angle = rad_to_deg(dir_vec.angle())
	var player_pos = self.player.global_position
	var x = player_pos.x + cos(angle) * self.radius
	var y = player_pos.y + sin(angle) * self.radius
	return Vector2(x,y)

func _process(delta: float) -> void:
	#pass
	#"""
	var progress = 1 - GameManager.game_timer.time_left / GameManager.game_timer.wait_time
	self.radius = lerpf(radius_min_start, radius_min_end, progress)
	"""

func _draw() -> void:
	if Engine.is_editor_hint():
		draw_circle($".".position,radius_max,Color.BLUE,false,5)
		draw_circle($".".position,radius_min_start,Color.RED,false,5)
		draw_circle($".".position,radius_min_end,Color.GREEN,false,5)
"""
