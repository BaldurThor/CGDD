class_name Experience extends Node

# Manages everything related to experience on the player-side

var current_experience: int = 0
var required_for_level_up: int = 10

signal gain_experience(amount: int)
signal update_experience_bar(experience: int)
signal level_up
@onready var pickup_sound_effect: AudioStreamPlayer2D = $PickupSoundEffect

func _ready() -> void:
	gain_experience.connect(_gain_experience)

func _gain_experience(amount: int) -> void:
	current_experience += amount
	pickup_sound_effect.pitch_scale = clamp(1.0 + (float(current_experience) / float(required_for_level_up)), 0.1, 2)
	pickup_sound_effect.play()
	update_experience_bar.emit(current_experience)
	
	if current_experience >= required_for_level_up:
		required_for_level_up *= 2.5
		level_up.emit()
