extends MarginContainer

@onready var back: Label = $CenterContainer/InfoMenu/VBoxContainer/HBoxContainer/Back

@export var how_to_play: Label

func _on_visibility_changed() -> void:
	if self.visible:
		back.grab_focus()
	elif how_to_play != null:
		how_to_play.grab_focus()
