class_name AbilityChoice extends Button

@onready var ability_name: Label = $VBoxContainer/Titlebar/Name
@onready var ability_icon: TextureRect = $VBoxContainer/Icon
@onready var positive_stats: VBoxContainer = $VBoxContainer/PositiveStats
@onready var negative_stats: VBoxContainer = $VBoxContainer/NegativeStats
@onready var flavor: Label = $VBoxContainer/Flavor
@onready var panel_container: PanelContainer = $PanelContainer
@onready var ability_details: VBoxContainer = $PanelContainer/VBoxContainer2/AbilityDetails

@onready var corrupted: TextureRect = $VBoxContainer/Titlebar/Rarities/Corrupted
@onready var rare: TextureRect = $VBoxContainer/Titlebar/Rarities/Rare
@onready var uncommon: TextureRect = $VBoxContainer/Titlebar/Rarities/Uncommon

const POSITIVE_STAT_INDICATOR = preload("res://player/hud/ability_choice/positive_stat_indicator.tscn")
const NEGATIVE_STAT_INDICATOR = preload("res://player/hud/ability_choice/negative_stat_indicator.tscn")
const TAG_DESCRIPTION = preload("res://player/ability_system/tag_description.tscn")

var ability: AbilityInfo = null
var _has_content: bool = false
var _show_content: bool = false

func init(ability_info: AbilityInfo):
	ability = ability_info

func _ready():
	modulate = Color("c8c8c8")
	ability_icon.texture = ability.icon
	ability_name.text = ability.name
	flavor.text = ability.flavor_text
	
	for positive_effect in ability.positive_effects:
		var indicator = POSITIVE_STAT_INDICATOR.instantiate()
		indicator.text = positive_effect
		positive_stats.add_child(indicator)
		
	for negative_effect in ability.negative_effects:
		var indicator = NEGATIVE_STAT_INDICATOR.instantiate()
		indicator.text = negative_effect
		negative_stats.add_child(indicator)
	
	if ability.rarity > 0:
		uncommon.show()
	if ability.rarity > 1:
		rare.show()
	if ability.rarity > 2:
		corrupted.show()
	
	_initialize_tags()

func _on_focus_entered() -> void:
	modulate = Color("ffffff")

func _on_focus_exited() -> void:
	modulate = Color("c8c8c8")

func _initialize_tags() -> void:
	panel_container.hide()
	for tag in ability.tags:
		var description = AbilityTagManager.get_tag_description(tag)
		if description != null:
			var tag_obj: Label = TAG_DESCRIPTION.instantiate()
			tag_obj.text = description
			tag_obj.z_index = self.z_index + 1
			ability_details.add_child(tag_obj)
			_has_content = true

func _process(delta: float) -> void:
	panel_container.visible = _show_content

func _on_mouse_entered() -> void:
	if _has_content:
		_show_content = true

func _on_mouse_exited() -> void:
	_show_content = false
