extends Node

var master_volume: float
var sfx_volume: float
var music_volume: float

var master_bus = AudioServer.get_bus_index("Master")
var sfx_bus = AudioServer.get_bus_index("Effects")
var music_bus = AudioServer.get_bus_index("Music")

const OPTIONS_FILE: String = "user://options.json"

const OPTIONS_MASTER_VOLUME_KEY = "master_volume"
const OPTIONS_SFX_VOLUME_KEY = "sfx_volume"
const OPTIONS_MUSIC_VOLUME_KEY = "music_volume"

func _ready() -> void:
	if not FileAccess.file_exists(OPTIONS_FILE):
		master_volume = db_to_linear(AudioServer.get_bus_volume_db(master_bus))
		sfx_volume = db_to_linear(AudioServer.get_bus_volume_db(sfx_bus))
		music_volume = db_to_linear(AudioServer.get_bus_volume_db(music_bus))
		return
	
	load_data()

func load_data() -> void:
	var save_file = FileAccess.open(OPTIONS_FILE, FileAccess.READ)
	var json_string = save_file.get_line()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return
	
	master_volume = json.data[OPTIONS_MASTER_VOLUME_KEY]
	sfx_volume = json.data[OPTIONS_SFX_VOLUME_KEY]
	music_volume = json.data[OPTIONS_MUSIC_VOLUME_KEY]
	pass

func save_data() -> void:
	var save_file = FileAccess.open(OPTIONS_FILE, FileAccess.WRITE)
	save_file.store_line(JSON.stringify({
		OPTIONS_MASTER_VOLUME_KEY: master_volume,
		OPTIONS_SFX_VOLUME_KEY: sfx_volume,
		OPTIONS_MUSIC_VOLUME_KEY: music_volume,
	}))
