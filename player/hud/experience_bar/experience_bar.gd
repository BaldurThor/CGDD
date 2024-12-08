class_name ExperienceBar extends ProgressBar

@onready var experience: Experience = %Experience

signal experience_bar_value_changed(current: int, max: int)

func _ready() -> void:
	experience.update_experience_bar.connect(_update_experience_bar)
	value = experience.current_experience
	max_value = experience.required_for_level_up
	step = 1
	_update_experience_bar(value)

func _update_experience_bar(_experience_amount: int) -> void:
	value = experience.current_experience
	max_value = experience.required_for_level_up
	experience_bar_value_changed.emit(value, max_value)
