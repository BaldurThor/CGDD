@icon("res://player/ability_system/bxs_category_alt.svg")
class_name AbilitySystem extends Node

@export var loot_table: AbilityPool
@onready var player_health: EntityHealth = %PlayerHealth
@onready var player_stats: PlayerStats = %PlayerStats
@onready var experience: Experience = %Experience
@onready var ability_picker: AbilityPicker = %AbilityPicker

func add_ability(ability: AbilityInfo):
	var ability_node: Ability = ability.ability_script.new()
	ability_node.apply_effects(player_stats, player_health)

func _on_experience_level_up() -> void:
	ability_picker.display_choice(
		loot_table.pick_ability(),
		loot_table.pick_ability(),
		loot_table.pick_ability(),
	)
