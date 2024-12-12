@tool
class_name FishSpawner extends Node2D

var player : Player

@export_group("Fish To Spawn")
@export var fish_scene : PackedScene

@export_group("Spawn Range")
@export var radius_max: int:
	set(value):
		radius_max = value
		queue_redraw()
		
@export var radius_min: int:
	set(value):
		radius_min = value
		queue_redraw()

@export_group("Total amount of fish")
# The maximun amount of fish on the level at any one time
@export var maximum : int = 5
# The minimum amount of fish on the level at any one time
@export var minimum : int = 1

var current_fish : int = 0

func polar_to_cart(angle : float, radius : float) -> Vector2:
	var x = cos(angle) * radius
	var y = sin(angle) * radius
	return Vector2(x,y)

func gen_cord() -> Vector2:
	var angle = randf_range(0, (2*PI))
	var radius = randf_range(radius_min,radius_max)
	return polar_to_cart(angle, radius)
	
func spawn_fish(cords : Vector2) -> void:
	var fish = fish_scene.instantiate()
	
	fish.set_position(cords)
	
	add_child(fish)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# get the player
	player = GameManager.get_player()
	var start_fish_ammount : int = randi_range(minimum, maximum)
	#print(start_fish_ammount)
	for a in start_fish_ammount: 
		var cords = gen_cord() + player.position
		spawn_fish(cords)
		
func _draw() -> void:
	return
	draw_circle($"../Player".position,radius_max,Color.DARK_SEA_GREEN,true,5)
	draw_circle($"../Player".position,radius_min,Color.DARK_RED,true,5)
