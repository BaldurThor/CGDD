extends HSlider

var bus = AudioServer.get_bus_index("Music")

func _ready() -> void:
	value = SaveManager.music_volume
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))
	self.set_value_no_signal(value)

func _on_value_changed(val: float) -> void:
	AudioServer.set_bus_volume_db(bus, linear_to_db(val))
	SaveManager.music_volume = val
