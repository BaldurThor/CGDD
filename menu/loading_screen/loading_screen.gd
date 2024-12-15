extends Control

@onready var progress_bar: ProgressBar = $ProgressBar

var target_scene_path: String

func _ready() -> void:
	target_scene_path = GameManager.scene_to_load
	ResourceLoader.load_threaded_request(target_scene_path)

func _process(_delta: float) -> void:
	var progress: Array[float]
	match ResourceLoader.load_threaded_get_status(target_scene_path, progress):
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			var load_progress = progress[0]
			progress_bar.value = load_progress
		ResourceLoader.THREAD_LOAD_LOADED:
			var scene = ResourceLoader.load_threaded_get(target_scene_path)
			get_tree().change_scene_to_packed(scene)
		ResourceLoader.THREAD_LOAD_FAILED:
			printerr("Error loading %s", target_scene_path)
