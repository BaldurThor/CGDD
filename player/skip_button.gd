class_name SkipButton extends Button

@export var base_string: String = ""
var player: Player = null

func _ready() -> void:
	player = GameManager.get_player()

func refresh_string(xp: int) -> void:
	text = base_string % str(xp)
