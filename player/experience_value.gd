extends Label

func _on_experience_bar_experience_bar_value_changed(current: int, max: int) -> void:
	text = "%s / %s" % [current, max]
