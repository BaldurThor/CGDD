class_name AbilitySelector extends VBoxContainer

@onready var ability_selection: HBoxContainer = $AbilitySelection
@onready var ability_system: AbilitySystem = %AbilitySystem
@onready var skip_button: SkipButton = $HBoxContainer/Control/SkipButton
@onready var backlog_count: Label = $HBoxContainer/HBoxContainer/BacklogCount
@onready var player: Player = $"../.."

const ABILITY_CHOICE = preload("res://player/hud/ability_choice/ability_choice.tscn")

var spent_skill_points: int = 0

enum ChoiceType {
	NORMAL,
	CORRUPTED,
	WEAPONS
}

var ability_queue: Array[ChoiceType] = []

func _ready() -> void:
	DebugCommands.connect("pick_ability", _on_DebugCommands_pick_ability)
	visible = false
	
func _get_skip_xp() -> int:
	if spent_skill_points == 0:
		return 0
	return player.experience.xp_needed_form(spent_skill_points)

func _request() -> void:
	var skip_xp: int = _get_skip_xp()
	skip_button.refresh_string(skip_xp)
	skip_button.visible = player.experience.current_level > 0
	_show_menu()
	
func request_weapon() -> void:
	_request()
	var weapons = ability_system.get_weapon_selection(3)
	for i in weapons.size():
		var weapon = weapons[i]
		add_choice(weapon, i)
		
func request_corrupted() -> void:
	_request()
	var abilities = ability_system.get_corrupted_abilities(3)
	for i in abilities.size():
		var ability = abilities[i]
		add_choice(ability, i)

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
	
	var skip_xp: int = _get_skip_xp()
	skip_button.refresh_string(skip_xp)
	skip_button.visible = player.experience.current_level > 0
	_show_menu()
	
	var choices = []
	match ability_queue.pop_front():
		ChoiceType.NORMAL: choices = ability_system.get_ability_selection()
		ChoiceType.WEAPONS: choices = ability_system.get_weapon_selection()
	
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
	_update_backlog_text()
	_refresh()

## Updates the text that indicates how many unspent skillpoints the player has
func _update_backlog_text() -> void:
	backlog_count.text = "%d" % [ability_queue.size()]

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
	_refresh()

func _on_DebugCommands_pick_ability(type : int = 0) -> void:
	match type:
		0: ability_queue.push_back(ChoiceType.NORMAL)
		1: request_corrupted()
		2: ability_queue.push_back(ChoiceType.WEAPONS)
