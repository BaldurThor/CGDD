extends Label

func _on_health_bar_health_ratio_changed(current: int, maximum: int) -> void:
	text = "%s / %s" % [current, maximum]
