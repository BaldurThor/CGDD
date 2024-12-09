extends Node2D

@onready var levels: Array[Node2D] = [
	$Level1,
	$Level2,
	$Level3,
	$Level4,
]

func _ready():
	GameManager.new_world_level.connect(_on_new_world_level)
	set_level(1)

func _on_new_world_level(new_level: int):
	set_level(new_level)

func set_level(level: int) -> void:
	for i in range(levels.size()):
		var active = i == level - 1
		var level_node = levels[i]
		
		var music: AudioStreamPlayer = level_node.get_node("Music")
		
		level_node.visible = active
		music.play() if active else music.stop()
