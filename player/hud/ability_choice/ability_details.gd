extends VBoxContainer

@onready var ability_choice: AbilityChoice = $"../../.."

var _has_content: bool = false
const TAG_DESCRIPTION = preload("res://player/ability_system/tag_description.tscn")
@onready var panel_container: PanelContainer = $"../.."

func _ready() -> void:
	panel_container.hide()
	for tag in ability_choice.ability.tags:
		var description = AbilityTagManager.get_tag_description(tag)
		if description != null:
			var tag_obj: Label = TAG_DESCRIPTION.instantiate()
			tag_obj.text = description
			tag_obj.z_index = self.z_index + 1
			add_child(tag_obj)
			_has_content = true

func _on_ability_choice_mouse_entered() -> void:
	if _has_content:
		panel_container.show()

func _on_ability_choice_mouse_exited() -> void:
	panel_container.hide()
