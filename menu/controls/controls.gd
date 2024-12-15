extends TextureRect

@onready var back_button: Button = $BackButton

func _on_visibility_changed() -> void:
	if back_button != null and self.visible:
		back_button.grab_focus()


func _on_back_button_pressed() -> void:
	hide()
