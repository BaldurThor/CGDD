extends HBoxContainer

@onready var panel_container: PanelContainer = $PanelContainer
@onready var hover_text: Label = $PanelContainer/MarginContainer/HoverText

var hover_text_content: String = ""
var _has_content: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hover_text.text = hover_text_content
	_has_content = hover_text_content != "" and hover_text_content != null


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	panel_container.global_position = get_global_mouse_position() - panel_container.size

func _on_mouse_entered() -> void:
	panel_container.visible = _has_content

func _on_mouse_exited() -> void:
	panel_container.visible = false
