extends Control

@export var info_node: Node
@export var options_node: Node

@onready var new_game: Button = $MenuOptions/StartGameButton
@onready var options: Control = $Options
@onready var options_button: Button = $MenuOptions/OptionsButton
@onready var controls: Control = $Controls
@onready var controls_button: Button = $MenuOptions/HowToPlayButton

func _ready() -> void:
	new_game.grab_focus()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if info_node.visible:
			info_node.hide()
		if options_node.visible:
			options_node.hide()


func _on_start_game_button_pressed() -> void:
	GameManager.start_game()

func _on_endless_mode_button_pressed() -> void:
	GameManager.start_endless_mode()

func _on_how_to_play_button_pressed() -> void:
	if options.visible:
		options.hide()
	
	if controls.visible:
		controls.hide()
	else:
		controls.show()

func _on_options_button_pressed() -> void:
	if controls.visible:
		controls.hide()
		
	if options.visible:
		options.hide()
	else:
		options.show()

func _on_quit_button_pressed() -> void:
	GameManager.quit()


func _on_info_hidden() -> void:
	controls_button.grab_focus()


func _on_options_hidden() -> void:
	options_button.grab_focus()
