class_name Experience extends Node

# Manages everything related to experience on the player-side

var current_experience: int = 0
var required_for_level_up: int = 10
signal gain_experience(amount: int)
signal update_experience_bar(experience: int)

func _ready() -> void:
	gain_experience.connect(_gain_experience)

func _gain_experience(amount: int) -> void:
	current_experience += amount
	update_experience_bar.emit(current_experience)
