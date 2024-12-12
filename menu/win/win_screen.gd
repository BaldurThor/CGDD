extends Control

@onready var fade: TextureRect = $Fade
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	GameManager.game_win.connect(_show_win_menu)
	visible = false

func _show_win_menu() -> void:
	GameManager.freeze_enemies = true
	visible = true
	var tween = get_tree().create_tween()
	tween.tween_property(fade, "modulate", Color(1.0, 1.0, 1.0, 1.0), 2.0)
	tween.tween_callback(_show_newspaper)

func _show_newspaper() -> void:
	animation_player.play("win_screen_popup")


func _on_endless_mode_button_pressed() -> void:
	GameManager.freeze_enemies = false
	GameManager.get_player().freeze_player = false
	visible = false

func _on_return_to_menu_button_pressed() -> void:
	GameManager.main_menu()
