extends TextureRect

@onready var back_button: Button = $BackButton

@onready var master_slider: HSlider = $Label/Master/MasterSlider
@onready var sfx_slider: HSlider = $Label/Effects/EffectsSlider
@onready var music_slider: HSlider = $Label/Music/MusicSlider
@onready var screenshake_slider: HSlider = $Label/Screenshake/ScreenshakeSlider

@export var options: Label

var master_bus = AudioServer.get_bus_index("Master")
var sfx_bus = AudioServer.get_bus_index("Effects")
var music_bus = AudioServer.get_bus_index("Music")

func _ready() -> void:
	master_slider.value = SaveManager.master_volume
	sfx_slider.value = SaveManager.sfx_volume
	music_slider.value = SaveManager.music_volume
	screenshake_slider.value = SaveManager.screenshake_amount
	AudioServer.set_bus_volume_db(master_bus, linear_to_db(SaveManager.master_volume))
	AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(SaveManager.sfx_volume))
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(SaveManager.music_volume))

func _on_visibility_changed() -> void:
	if back_button != null and visible:
		back_button.grab_focus()

func _on_back_button_pressed() -> void:
	hide()


func _on_master_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(master_bus, linear_to_db(value))
	SaveManager.master_volume = value


func _on_effects_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(value))
	SaveManager.sfx_volume = value


func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(value))
	SaveManager.music_volume = value


func _on_screenshake_slider_value_changed(value: float) -> void:
	SaveManager.screenshake_amount = value
