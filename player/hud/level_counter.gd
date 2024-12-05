extends Label

@onready var experience: Experience = %Experience

func _ready() -> void:
	experience.level_up.connect(_update_counter)
	_update_counter()

func _update_counter() -> void:
	text = "%d" % [experience.current_level]
