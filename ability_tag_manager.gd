extends Node

var tags: AbilityTags = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tags = load("res://player/ability_system/ability_tag_details.tres")

## Returns a string or null
func get_tag_description(tag_name: String) -> Variant:
	return tags.get_tag_description(tag_name)
