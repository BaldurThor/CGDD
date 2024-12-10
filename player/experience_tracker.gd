class_name Experience extends Node

# Manages everything related to experience on the player-side

var current_experience: int = 0
var current_level : int = 0
var required_for_level_up: int = xp_needed_form(0)

signal gain_experience(amount: int)
signal update_experience_bar(experience: int)
signal level_up()

@onready var pickup_sound_effect: AudioStreamPlayer2D = $PickupSoundEffect
@onready var player_stats: PlayerStats = %PlayerStats

func _ready() -> void:
	gain_experience.connect(_gain_experience)


func xp_needed_form(level : int) -> int:
	"""
	does some funky math 
	to find out how much xp is needed
	to level up to the next level
	"""

	return (level ** 2) + (3 * level) + 10

func _gain_experience(amount: int) -> void:
	current_experience += int(amount * player_stats.experience_gain_mod)
	pickup_sound_effect.pitch_scale = clamp(1.0 + (float(current_experience) / float(required_for_level_up)), 0.1, 2)
	pickup_sound_effect.play()
	update_experience_bar.emit(current_experience)
	
	var levelled_up = false
	while current_experience >= required_for_level_up:
		levelled_up = true
		current_level += 1
		current_experience -= required_for_level_up
		update_experience_bar.emit(current_experience)
		required_for_level_up = xp_needed_form(current_level)
		level_up.emit()
