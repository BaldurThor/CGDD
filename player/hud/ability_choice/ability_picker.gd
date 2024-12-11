class_name AbilityPicker extends VBoxContainer

@onready var ability_selection: HBoxContainer = $AbilitySelection
@onready var ability_system: AbilitySystem = %AbilitySystem
@onready var skip_button: SkipButton = $HBoxContainer/Control/SkipButton
@onready var backlog_count: Label = $HBoxContainer/HBoxContainer/BacklogCount

const ABILITY_CHOICE = preload("res://player/hud/ability_choice/ability_choice.tscn")

enum ChoiceType {
	NORMAL,
	CORRUPTED,
	WEAPONS
}

var backlog: Array[ChoiceType] = []

func _ready() -> void:
	DebugCommands.connect("pick_ability",_on_DebugCommands_pick_ability)
	visible = false
	GameManager.boss_killed.connect(_on_boss_killed)

func refresh() -> void:
	for child in ability_selection.get_children():
		child.queue_free()
	
	if backlog.size() == 0:
		visible = false
		GameManager.unpause(self)
		return
	
	GameManager.pause(self)
	skip_button.refresh_string(backlog[0])
	skip_button.visible = GameManager.get_player().experience.current_level > 0
	visible = true
	
	var choices = []
	match backlog[0]:
		ChoiceType.NORMAL: choices = ability_system.loot_table.get_ability_selection()
		ChoiceType.CORRUPTED: choices = ability_system.loot_table.get_corrupted_abilities()
		ChoiceType.WEAPONS: choices = ability_system.loot_table.get_weapon_selection()
	
	for index in choices.size():
		add_choice(choices[index], index)

func add_choice(ability: AbilityInfo, index: int) -> void:
	var choice: AbilityChoice = ABILITY_CHOICE.instantiate()
	choice.init(ability)
	choice.pressed.connect(func(): pick_ability(ability))
	ability_selection.add_child(choice)
	if index == 0:
		choice.grab_focus()

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

func _on_boss_killed(boss: Boss) -> void:
	add_to_backlog(ChoiceType.CORRUPTED)

func _on_game_start() -> void:
	add_to_backlog(ChoiceType.WEAPONS)

func _on_DebugCommands_pick_ability(type : int = 1) -> void:
	type -= 1
	add_to_backlog(type as ChoiceType)

func _get_skip_experience_multiplier(type: AbilityInfo.AbilityType) -> float:
	var exp_mult: float = 0.0
	match type:
		AbilityInfo.AbilityType.CORRUPTED:
			exp_mult = 1.0
		_:
			exp_mult = 0.5
	return exp_mult

func _on_skip_button_button_up() -> void:
	var type = backlog.pop_front()
	var player = GameManager.get_player()
	var exp_mult = _get_skip_experience_multiplier(type)
	var experience_for_skipping: int = int(player.experience.required_for_level_up * exp_mult)
	player.experience.gain_experience.emit(experience_for_skipping, false)
	refresh()
