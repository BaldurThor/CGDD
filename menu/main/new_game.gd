extends Label

@export var run: PackedScene

func _on_gui_input(event: InputEvent) -> void:
	if event.is_pressed():
		var main = get_node("/root/Main")
		main.remove_child(get_node("/root/Main/Menu"))
		main.add_child(run.instantiate())


func _on_mouse_entered() -> void:
	self.add_theme_color_override("font_color", Color(1,0,0))


func _on_mouse_exited() -> void:
	self.add_theme_color_override("font_color", Color(1,1,1))
