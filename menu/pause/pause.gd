extends CanvasLayer

@export var info_node: Node
@export var options_node: Node



func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if info_node.visible or options_node.visible:
			info_node.hide()
			options_node.hide()
			return
		
		visible = not visible
		GameManager.set_pause(self, visible)
