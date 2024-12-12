extends Label

@export var options: Node
@export var info: Node

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_left") or event.is_action_pressed("ui_accept"):
		if options.visible:
			options.hide()
		
		if info.visible:
			info.hide()
		else:
			info.show()

func _on_mouse_entered() -> void:
	self.add_theme_color_override("font_color", Color(1,0,0))


func _on_mouse_exited() -> void:
	self.add_theme_color_override("font_color", Color(1,1,1))


func _on_focus_entered() -> void:
	self.add_theme_color_override("font_color", Color(1,0,0))


func _on_focus_exited() -> void:
	self.add_theme_color_override("font_color", Color(1,1,1))
