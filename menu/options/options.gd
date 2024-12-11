extends MarginContainer

@onready var back: Label = $CenterContainer/OptionsMenu/VBoxContainer/Split/Button/Back

@export var options: Label

func _on_visibility_changed() -> void:
	if self.visible:
		back.grab_focus()
	elif options != null:
		options.grab_focus()
