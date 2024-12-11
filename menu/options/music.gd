extends HSlider

var bus = AudioServer.get_bus_index("Music")
@onready var label: Label = $"../../Label/Music"

func _ready() -> void:
	value = SaveManager.music_volume
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))
	self.set_value_no_signal(value)
	value_changed.connect(_on_value_changed)

func _on_value_changed(val: float) -> void:
	AudioServer.set_bus_volume_db(bus, linear_to_db(val))
	SaveManager.music_volume = val


func _on_focus_entered() -> void:
	label.add_theme_color_override("font_color", Color(1,0,0))

func _on_focus_exited() -> void:
	label.add_theme_color_override("font_color", Color(1,1,1))
