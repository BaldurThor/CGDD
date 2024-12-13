class_name TimeRemainingUI extends Control

@onready var minutes: Label = $Minutes
@onready var seconds: Label = $Seconds

func _process(_delta: float) -> void:
	var time_remaining: int = GameManager.get_time_left()
	if time_remaining >= 5999:
		time_remaining = 5999
	self.minutes.text = str(int(time_remaining) / 60).pad_zeros(2)
	self.seconds.text = str(int(time_remaining) % 60).pad_zeros(2)
