extends AudioStreamPlayer2D

func _process(_delta: float) -> void:
	# This is cursed... dw about it
	var player = GameManager.get_player()
	if player != null:
		position = player.position
