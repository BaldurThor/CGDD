class_name AbilityTags extends Resource

## TagName/Description
@export var _tags: Dictionary = {}

## Returns a string or null
func get_tag_description(tag_name: String) -> Variant:
	var tag = _tags.get(tag_name)
	if !tag:
		print_debug("[AbilityTags]: TAG NOT FOUND: ", tag_name)
	return tag
