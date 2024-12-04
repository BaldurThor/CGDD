extends MarginContainer

@export var info_node: Node
@export var options_node: Node

func _ready() -> void:
	get_tree().paused = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if info_node.visible:
			info_node.hide()
		if options_node.visible:
			options_node.hide()
