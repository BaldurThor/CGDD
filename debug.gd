class_name debug extends Node

#Constants
var CONSOLE_SCENE = preload("res://debug/console.tscn")

# FLags
var enable: bool = false # ebable addisional debug info
var console_enabled : bool = false

# Console Stuff
var expression : Expression = null
var console_scene : Node = null
var console_out : RichTextLabel = null
var console_in : LineEdit = null

func _ready() -> void:
	make_console()

# makes the console and sets all needed variables
func make_console() -> void:
	set_process_mode(PROCESS_MODE_ALWAYS)
	expression = Expression.new()
	console_scene = CONSOLE_SCENE.instantiate()
	add_child(console_scene)
	console_out = console_scene.get_child(0)
	console_in = console_scene.get_child(1)
	console_scene.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug_open"):

		console_enabled = false if console_enabled else true
		console_scene.visible = console_enabled
		
		if console_enabled:
			console_in.grab_focus()
		else:
			console_in.clear()
			
		get_tree().paused = console_enabled
