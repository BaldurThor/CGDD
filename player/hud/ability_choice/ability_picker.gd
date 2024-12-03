class_name AbilityPicker extends VBoxContainer

@onready var ability_selection: HBoxContainer = $AbilitySelection
@onready var ability_system: AbilitySystem = %AbilitySystem

const ABILITY_CHOICE = preload("res://player/hud/ability_choice/ability_choice.tscn")

func _ready() -> void:
	visible = false

func display_choice(ability1: AbilityInfo, ability2: AbilityInfo, ability3: AbilityInfo):
	visible = true
	
	add_choice(ability1)
	add_choice(ability2)
	add_choice(ability3)

func add_choice(ability: AbilityInfo):
	var choice: AbilityChoice = ABILITY_CHOICE.instantiate()
	choice.init(ability)
	choice.pressed.connect(func(): pick_ability(ability))
	ability_selection.add_child(choice)

func pick_ability(ability: AbilityInfo):
	for child in ability_selection.get_children():
		child.queue_free()
	
	visible = false
	ability_system.add_ability(ability)
