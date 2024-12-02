extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().paused:
			hide()
			get_tree().paused = false
		else:
			show()
			get_tree().paused = true
