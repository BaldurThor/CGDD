extends CanvasLayer

@export var info_node: Node
@export var options_node: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if not get_tree().paused:
			show()
			get_tree().paused = true
		elif info_node.visible:
			info_node.hide()
		elif options_node.visible:
			options_node.hide()
		else:
			hide()
			get_tree().paused = false
