extends Label

var menu = load("res://menu/main/menu.tscn") as PackedScene

func _on_mouse_entered() -> void:
	self.add_theme_color_override("font_color", Color(1,0,0))


func _on_mouse_exited() -> void:
	self.add_theme_color_override("font_color", Color(1,1,1))


func _on_gui_input(event: InputEvent) -> void:
	if event.is_pressed():
		var main = get_node("/root/Main")
		main.remove_child(get_node("/root/Main/Run"))
		main.add_child(menu.instantiate())
