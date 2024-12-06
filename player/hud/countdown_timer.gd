class_name TimeRemainingUI extends Label

func _process(delta: float) -> void:
	var time_remaining: int = int(GameManager.game_timer.time_left)
	var minutes: String = str(time_remaining / 60).pad_zeros(2)
	var seconds: String = str(time_remaining % 60).pad_zeros(2)
	text = minutes + ":" + seconds
