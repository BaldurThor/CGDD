extends Node

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
	# make this script unpausable 
	set_process_mode(PROCESS_MODE_ALWAYS)
	
	
func assigne_console_out(obj : RichTextLabel) -> void:
	console_out = obj
	
func assigne_console_in(obj : LineEdit) -> void:
	console_in = obj

# makes the console and sets all needed variables
func make_console() -> void:

	expression = Expression.new()
	console_scene = CONSOLE_SCENE.instantiate()
	
	add_child(console_scene)
	console_scene.visible = false
	
	# make a signal for when text is edited
	console_in.text_submitted.connect(self._on_text_submitted)

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
		
func _on_text_submitted(text) -> void:
	var parse_err = expression.parse(text)
	# code that runs if there is an error
	if parse_err != OK:
		console_out.text += expression.get_error_text() + "\n"
	
	var res = expression.execute([], DebugCommands)
	console_out.text += str(res) + "\n"
