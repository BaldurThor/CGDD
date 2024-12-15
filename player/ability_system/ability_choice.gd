class_name AbilityChoice extends Button

@onready var ability_name: Label = $Name
@onready var ability_icon: TextureRect = $Icon
@onready var positive_stats: VBoxContainer = $Stats/PositiveStats
@onready var negative_stats: VBoxContainer = $Stats/NegativeStats
@onready var flavor: Label = $Stats/Flavor
@onready var stats: VBoxContainer = $Stats

@onready var corrupted: TextureRect = $Rarities/Corrupted
@onready var rare: TextureRect = $Rarities/Rare
@onready var uncommon: TextureRect = $Rarities/Uncommon

const POSITIVE_STAT_INDICATOR = preload("res://player/hud/ability_choice/positive_stat_indicator.tscn")
const NEGATIVE_STAT_INDICATOR = preload("res://player/hud/ability_choice/negative_stat_indicator.tscn")

var ability: AbilityInfo = null

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

func _on_focus_entered() -> void:
	modulate = Color("ffffff")

func _on_focus_exited() -> void:
	modulate = Color("c8c8c8")
