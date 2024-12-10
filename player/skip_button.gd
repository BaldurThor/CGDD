class_name SkipButton extends Button

@export var base_string: String = ""
var player: Player = null

func _ready() -> void:
	player = GameManager.get_player()

func refresh_string(choice: AbilityPicker.ChoiceType) -> void:
	var player_xp_required = player.experience.required_for_level_up
	var skip_mod = 1.0 if choice == AbilityPicker.ChoiceType.CORRUPTED else 0.5
	text = base_string % str(int(player_xp_required * skip_mod))
