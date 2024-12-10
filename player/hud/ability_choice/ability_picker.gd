class_name AbilityPicker extends VBoxContainer

@onready var ability_selection: HBoxContainer = $AbilitySelection
@onready var ability_system: AbilitySystem = %AbilitySystem
@onready var backlog_count: Label = $HBoxContainer/BacklogCount

const ABILITY_CHOICE = preload("res://player/hud/ability_choice/ability_choice.tscn")

var backlog: int = 0
var corrupted_backlog: int = 0

func _ready() -> void:
	visible = false

func refresh_corrupted() -> void:
	_refresh_choices()
	if corrupted_backlog == 0:
		visible = false
		GameManager.unpause(self)
		return
	
	GameManager.pause(self)
	visible = true
	
	var choices = ability_system.loot_table.get_corrupted_abilities()
	
	for choice in choices:
		add_corrupted_choice(choice)

func refresh_normal() -> void:
	_refresh_choices()
	if backlog == 0:
		visible = false
		GameManager.unpause(self)
		return
	
	GameManager.pause(self)
	visible = true
	
	var choices = ability_system.loot_table.get_ability_selection()
	
	for choice in choices:
		add_choice(choice)

func _refresh_choices():
	for child in ability_selection.get_children():
		child.queue_free()

func add_choice(ability: AbilityInfo):
	var choice: AbilityChoice = ABILITY_CHOICE.instantiate()
	choice.init(ability)
	choice.pressed.connect(func(): pick_ability(ability))
	ability_selection.add_child(choice)

func add_corrupted_choice(ability: AbilityInfo):
	var choice: AbilityChoice = ABILITY_CHOICE.instantiate()
	choice.init(ability)
	choice.pressed.connect(func(): pick_corrupted(ability))
	ability_selection.add_child(choice)

func pick_ability(ability: AbilityInfo):
	ability_system.add_ability(ability)
	backlog -= 1
	backlog_count.text = "%d" % [backlog]
	refresh_normal()

func pick_corrupted(ability: AbilityInfo):
	ability_system.add_ability(ability)
	refresh_normal()

func _on_experience_level_up() -> void:
	backlog += 1
	backlog_count.text = "%d" % [backlog]
	
	if backlog == 1:
		refresh_normal()

## TODO: Replace this signal connection with one that is emitted when a miniboss dies
func _on_level_switcher_level_switched() -> void:
	corrupted_backlog += 1
	refresh_corrupted()
