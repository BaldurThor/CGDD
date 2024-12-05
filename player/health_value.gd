extends Label

func _on_health_bar_health_ratio_changed(current: int, max: int) -> void:
	text = "%s / %s" % [current, max]
