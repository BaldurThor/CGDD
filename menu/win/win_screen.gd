extends Control

@onready var fade: TextureRect = $Fade
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var stats: VBoxContainer = $Controls/Stats
@onready var endless_mode_button: Button = $Controls/HBoxContainer/EndlessModeButton
@onready var submit_score_button: Button = $Controls/SubmitMenu/HBoxContainer/SubmitScoreButton
@onready var submit_menu: ColorRect = $Controls/SubmitMenu
@onready var open_submit_score_button: Button = $Controls/HBoxContainer/SubmitScoreButton

var player_name: String

const SHOCKWAVE = preload("res://levels/transition/shockwave.tscn")

func _ready() -> void:
	GameManager.game_win.connect(_show_win_menu)
	visible = false

func _show_win_menu() -> void:
	GameManager.freeze_enemies = true
	visible = true
	var tween = get_tree().create_tween()
	tween.tween_property(fade, "modulate", Color(1.0, 1.0, 1.0, 1.0), 2.0)
	tween.tween_callback(_show_newspaper)
	stats.show_stats()
	await animation_player.animation_finished
	endless_mode_button.grab_focus()

func _show_newspaper() -> void:
	animation_player.play("win_screen_popup")


func _on_endless_mode_button_pressed() -> void:
	GameManager.endless_mode()
	visible = false
	var shockwave = SHOCKWAVE.instantiate()
	GameManager.get_game_root().add_child(shockwave)
	shockwave.global_position = GameManager.get_player().global_position

func _on_return_to_menu_button_pressed() -> void:
	GameManager.main_menu()


func _on_line_edit_text_submitted(new_text: String) -> void:
	player_name = new_text
	submit_score_button.grab_focus()


func _on_submit_score_button_pressed() -> void:
	if player_name == "":
		return
	
	GameManager.get_stats_man().submit.emit(player_name)
	submit_menu.hide()
	endless_mode_button.grab_focus()
	open_submit_score_button.disabled = true


func _on_line_edit_text_changed(new_text: String) -> void:
	player_name = new_text
