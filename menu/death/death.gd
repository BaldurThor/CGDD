extends Node

@onready var highlight_screen: ColorRect = %EnemyHighlightScreen
@onready var death_menu: CanvasLayer = %DeathMenu
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var stats: VBoxContainer = $DeathMenu/Controls/Stats
@onready var retry_button: Button = $DeathMenu/Controls/HBoxContainer/RetryButton
@onready var submit_menu: ColorRect = $DeathMenu/SubmitMenu
@onready var submit_score: Button = $DeathMenu/Controls/HBoxContainer/SubmitScore
@onready var submit_score_button: Button = $DeathMenu/SubmitMenu/HBoxContainer/SubmitScoreButton

var enemy: Enemy
var player_name: String = ""

func initialize(killer: Enemy) -> void:
	enemy = killer
	enemy.enemy_base.sprite_2d.z_index = 2

func _ready() -> void:
	GameManager.pause(self)
	GameManager._player.level_switcher.stop_music()
	animation_player.play("death")
	stats.show_stats()
	retry_button.grab_focus()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		animation_player.stop()
		animation_player.play("RESET")

func _on_retry_button_pressed() -> void:
	GameManager.start_game()

func _on_quit_to_menu_button_pressed() -> void:
	GameManager.main_menu()


func _on_submit_score_button_pressed() -> void:
	if player_name == "":
		return
	
	GameManager.get_stats_man().submit.emit(player_name)
	submit_menu.hide()
	retry_button.grab_focus()
	submit_score.disabled = true

func _on_line_edit_text_submitted(new_text: String) -> void:
	player_name = new_text
	submit_score_button.grab_focus()

func _on_line_edit_text_changed(new_text: String) -> void:
	player_name = new_text
