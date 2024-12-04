class_name AbilityChoice extends Button

@onready var texture_rect: TextureRect = $VBoxContainer/TextureRect
@onready var label: Label = $VBoxContainer/Label

var ability: AbilityInfo = null

func init(ability_info: AbilityInfo):
	ability = ability_info

func _ready():
	texture_rect.texture = ability.icon
	label.text = ability.name
