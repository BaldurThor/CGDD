class_name AbilityPicker extends VBoxContainer

@onready var ability_selection: HBoxContainer = $AbilitySelection
@onready var ability_system: AbilitySystem = %AbilitySystem
@onready var backlog_count: Label = $HBoxContainer/BacklogCount

const ABILITY_CHOICE = preload("res://player/hud/ability_choice/ability_choice.tscn")

enum ChoiceType {
	NORMAL,
	CORRUPTED
}

var backlog: Array[ChoiceType] = []

func _ready() -> void:
	visible = false

func refresh() -> void:
	for child in ability_selection.get_children():
		child.queue_free()
	
	if backlog.size() == 0:
		visible = false
		GameManager.unpause(self)
		return
	
	GameManager.pause(self)
	visible = true
	
	var choices = []
	match backlog[0]:
		ChoiceType.NORMAL: choices = ability_system.loot_table.get_ability_selection()
		ChoiceType.CORRUPTED: choices = ability_system.loot_table.get_corrupted_abilities()
	
	for choice in choices:
		add_choice(choice)

func add_choice(ability: AbilityInfo) -> void:
	var choice: AbilityChoice = ABILITY_CHOICE.instantiate()
	choice.init(ability)
	choice.pressed.connect(func(): pick_ability(ability))
	ability_selection.add_child(choice)

func pick_ability(ability: AbilityInfo) -> void:
	ability_system.add_ability(ability)
	backlog.pop_front()
	backlog_count.text = "%d" % [backlog.size()]
	refresh()

func add_to_backlog(choice_type: ChoiceType) -> void:
	backlog.append(choice_type)
	backlog_count.text = "%d" % [backlog.size()]
	
	if backlog.size() == 1:
		refresh()

func _on_experience_level_up() -> void:
	add_to_backlog(ChoiceType.NORMAL)

## TODO: Replace this signal connection with one that is emitted when a miniboss dies
func _on_level_switcher_level_switched() -> void:
	add_to_backlog(ChoiceType.CORRUPTED)
