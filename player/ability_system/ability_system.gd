@icon("res://player/ability_system/bxs_category_alt.svg")
class_name AbilitySystem extends Node

@export var loot_table: AbilityPool
@onready var experience: Experience = %Experience

func add_ability(ability: AbilityInfo):
	var ability_node: Ability = ability.ability_script.new()
	var player_stats: PlayerStats = GameManager.get_player().player_stats
	loot_table.add_ability_pick_count(ability)
	ability_node.init(GameManager.get_player())
	ability_node.apply_effects(player_stats)
	GameManager.pickup_ability.emit(ability)
