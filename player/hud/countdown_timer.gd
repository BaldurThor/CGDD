class_name TimeRemainingUI extends HBoxContainer

@onready var minutes: Label = $Minutes
@onready var seconds: Label = $Seconds

func _process(_delta: float) -> void:
	var time_remaining: int = int(GameManager.game_timer.time_left)
	self.minutes.text = str(int(time_remaining) / 60).pad_zeros(2)
	self.seconds.text = str(int(time_remaining) % 60).pad_zeros(2)
