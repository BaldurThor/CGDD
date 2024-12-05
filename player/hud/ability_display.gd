extends VBoxContainer

func _ready() -> void:
	GameManager.pickup_ability.connect(_on_pickup_ability)

func _on_pickup_ability(ability: AbilityInfo) -> void:
	var icon = TextureRect.new()
	add_child(icon)
	icon.texture = ability.icon
	icon.custom_minimum_size = Vector2.ONE * 32
