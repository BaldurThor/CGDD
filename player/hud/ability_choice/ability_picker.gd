class_name AbilityPicker extends VBoxContainer

@onready var ability_selection: HBoxContainer = $AbilitySelection
@onready var ability_system: AbilitySystem = %AbilitySystem
@onready var backlog_count: Label = $HBoxContainer/BacklogCount

const ABILITY_CHOICE = preload("res://player/hud/ability_choice/ability_choice.tscn")

var backlog: int = 0

func _ready() -> void:
	visible = false

func refresh_choices():
	for child in ability_selection.get_children():
		child.queue_free()
	
	if backlog == 0:
		visible = false
		get_tree().paused = false
		GameManager.lvl_up = false
		return
	
	visible = true
	
	var choices = ability_system.loot_table.get_ability_selection()
	
	for choice in choices:
		add_choice(choice)

func add_choice(ability: AbilityInfo):
	var choice: AbilityChoice = ABILITY_CHOICE.instantiate()
	choice.init(ability)
	choice.pressed.connect(func(): pick_ability(ability))
	ability_selection.add_child(choice)

func pick_ability(ability: AbilityInfo):
	ability_system.add_ability(ability)
	backlog -= 1
	backlog_count.text = "%d" % [backlog]
	refresh_choices()

func _on_experience_level_up() -> void:
	backlog += 1
	backlog_count.text = "%d" % [backlog]
	
	if backlog == 1:
		refresh_choices()
