class_name AbilitySelector extends Control

@onready var ability_selection: HBoxContainer = $AbilitySelectorMenu/AbilitySelection
@onready var ability_system: AbilitySystem = %AbilitySystem
@onready var skip_button: SkipButton = $AbilitySelectorMenu/HBoxContainer/SkipButton
@onready var player: Player = $"../.."
@onready var skill_bullet: SkillBullet = $"../SkillBullet"
@onready var select_label: Label = $AbilitySelectorMenu/Label

@export var select_text_weapons: String = "Select Weapon"
@export var select_text_fish: String = "Select Fish"
@export var select_text_corrupted: String = "Select Corrupted"
@export var select_text_normal: String = "Select Ability"

const ABILITY_CHOICE = preload("res://player/hud/ability_choice/ability_choice.tscn")

var spent_skill_points: int = 0

enum ChoiceType {
	NORMAL,
	CORRUPTED,
	WEAPONS
}

var active_type: ChoiceType

var ability_queue: Array[ChoiceType] = []

func _ready() -> void:
	DebugCommands.connect("pick_ability", _on_DebugCommands_pick_ability)
	visible = false
	
func _get_skip_xp() -> int:
	var mul: float = 0.0
	match active_type:
		ChoiceType.CORRUPTED: mul = ability_system.loot_table.corrupted_skip_xp_multiplier
		ChoiceType.WEAPONS: mul = ability_system.loot_table.weapon_skip_xp_multiplier
		ChoiceType.NORMAL: mul = ability_system.loot_table.passive_skip_xp_multiplier
	return int(player.experience.xp_needed_form(spent_skill_points) * mul)

func _request() -> void:
	var skip_xp: int = _get_skip_xp()
	skip_button.refresh_string(skip_xp)
	skip_button.visible = player.experience.current_level > 0
	_show_menu()
	
func request_weapon() -> void:
	ability_queue.push_front(ChoiceType.WEAPONS)
	_refresh()
		
func request_corrupted() -> void:
	ability_queue.push_front(ChoiceType.CORRUPTED)
	_refresh()

func request_menu() -> void:
	if ability_queue.size() > 0 and !visible:
		_refresh()
		
func _close_menu() -> void:
	visible = false
	GameManager.unpause(self)
	
func _show_menu() -> void:
	visible = true
	GameManager.pause(self)
	_update_backlog_text()

func _refresh() -> void:
	for child in ability_selection.get_children():
		child.queue_free()
	
	if ability_queue.size() == 0:
		_close_menu()
		return
	
	match active_type:
		ChoiceType.WEAPONS: select_label.text = select_text_weapons
		ChoiceType.CORRUPTED: select_label.text = select_text_corrupted
		ChoiceType.NORMAL: select_label.text = select_text_normal
	
	_show_menu()
	var choices = []
	active_type = ability_queue.pop_front()
	var skip_xp: int = _get_skip_xp()
	skip_button.refresh_string(skip_xp)
	skip_button.visible = player.experience.current_level > 0
	
	match active_type:
		ChoiceType.NORMAL: choices = ability_system.get_ability_selection()
		ChoiceType.WEAPONS: choices = ability_system.get_weapon_selection()
		ChoiceType.CORRUPTED: choices = ability_system.get_corrupted_abilities()
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
	if ability.rarity == AbilityInfo.Rarity.CORRUPTED:
		_close_menu()
		return
	# Small hack to get the tracker not to count the first weapon pick as a skill point
	if player.experience.current_level > 0:
		spent_skill_points += 1
	_refresh()

## Updates the text that indicates how many unspent skillpoints the player has
func _update_backlog_text() -> void:
	skill_bullet.set_skill_bullet_count(ability_queue.size())

## Adds a skill point for the player to use later
func _on_experience_level_up() -> void:
	if player.experience.current_level % ability_system.loot_table.weapon_guarantee_breakpoint == 0:
		ability_queue.push_back(ChoiceType.WEAPONS)
	else:
		ability_queue.push_back(ChoiceType.NORMAL)

## Grants the player experience in exchange for one of their skill points
func _on_skip_button_button_up() -> void:
	var xp = _get_skip_xp()
	player.experience.gain_experience.emit(xp, false)
	spent_skill_points += 1
	if active_type == ChoiceType.CORRUPTED:
		_close_menu()
		return
	_refresh()

func _on_DebugCommands_pick_ability(type : int = 0) -> void:
	match type:
		0: ability_queue.push_back(ChoiceType.NORMAL)
		1: request_corrupted()
		2: ability_queue.push_back(ChoiceType.WEAPONS)
