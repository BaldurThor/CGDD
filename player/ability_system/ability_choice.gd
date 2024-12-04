class_name AbilityChoice extends Button

@onready var ability_name: Label = $VBoxContainer/Name
@onready var ability_icon: TextureRect = $VBoxContainer/Icon
@onready var positive_stats: VBoxContainer = $VBoxContainer/PositiveStats
@onready var negative_stats: VBoxContainer = $VBoxContainer/NegativeStats
@onready var flavor: Label = $VBoxContainer/Flavor

const POSITIVE_STAT_INDICATOR = preload("res://player/hud/ability_choice/positive_stat_indicator.tscn")
const NEGATIVE_STAT_INDICATOR = preload("res://player/hud/ability_choice/negative_stat_indicator.tscn")

var ability: AbilityInfo = null

func init(ability_info: AbilityInfo):
	ability = ability_info

func _ready():
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
