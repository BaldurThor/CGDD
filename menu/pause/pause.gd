class_name PauseUI extends CanvasLayer

@onready var info_node: TextureRect = $Info
@onready var options_node: TextureRect = $Options
@onready var options_button: Button = $MenuOptions/OptionsButton
@onready var controls_button: Button = $MenuOptions/ControlsButton
@onready var continue_button: Button = $MenuOptions/ContinueButton
@onready var stats: StatsUI = $Stats

func _process(_delta: float) -> void:
	if not GameManager.death:
		if Input.is_action_just_pressed("ui_cancel"):
			if info_node.visible or options_node.visible:
				info_node.hide()
				options_node.hide()
				return
			
			visible = not visible
			GameManager.set_pause(self, visible)



func _on_visibility_changed() -> void:
	if self.visible:
		continue_button.grab_focus()
		stats.show_stats()


func _on_continue_button_pressed() -> void:
	hide()
	GameManager.unpause(self)


func _on_controls_button_pressed() -> void:
	if options_node.visible:
		options_node.hide()
	
	if info_node.visible:
		info_node.hide()
	else:
		info_node.show()


func _on_options_button_pressed() -> void:
	if info_node.visible:
		info_node.hide()
		
	if options_node.visible:
		options_node.hide()
	else:
		options_node.show()


func _on_reset_run_button_pressed() -> void:
	GameManager.start_game()


func _on_quit_to_menu_button_pressed() -> void:
	GameManager.main_menu()


func _on_info_hidden() -> void:
	controls_button.grab_focus()


func _on_options_hidden() -> void:
	options_button.grab_focus()
