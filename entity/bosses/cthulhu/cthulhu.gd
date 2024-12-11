class_name Cthulhu extends Boss

func _ready() -> void:
	super()
	enemy_base.destroy_object.connect(_on_death)

func _on_death() -> void:
	GameManager.game_win.emit()
