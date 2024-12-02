@icon("res://assets/icons/editor/bxs_category_alt.svg")
class_name AbilitySystem extends Node

@export var loot_table: AbilityPool
@onready var player_health: EntityHealth = %PlayerHealth
@onready var player_stats: PlayerStats = %PlayerStats

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.keycode == KEY_G:
		add_ability(loot_table.pick_ability())

func add_ability(ability: AbilityInfo):
	var ability_node: Ability = ability.ability_script.new()
	ability_node.apply_effects(player_stats, player_health)
