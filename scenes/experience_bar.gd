class_name ExperienceBar extends ProgressBar

@onready var experience: Experience = %Experience

func _ready() -> void:
	experience.update_experience_bar.connect(_update_experience_bar)
	value = experience.current_experience
	max_value = experience.required_for_level_up
	step = 1

func _update_experience_bar(experience_amount: int) -> void:
	value = experience.current_experience
	max_value = experience.required_for_level_up
