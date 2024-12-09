extends Label

func _on_mouse_entered() -> void:
	self.add_theme_color_override("font_color", Color(1,0,0))


func _on_mouse_exited() -> void:
	self.add_theme_color_override("font_color", Color(1,1,1))


func _on_gui_input(event: InputEvent) -> void:
	if event.is_pressed():
		GameManager.main_menu()
