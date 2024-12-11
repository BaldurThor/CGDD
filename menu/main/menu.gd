extends MarginContainer

@export var info_node: Node
@export var options_node: Node
@onready var new_game: Label = $HBoxContainer/VBoxContainer/MenuOptions/NewGame

func _ready() -> void:
	new_game.grab_focus()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if info_node.visible:
			info_node.hide()
		if options_node.visible:
			options_node.hide()
