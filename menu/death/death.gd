extends Node

@onready var highlight_screen: ColorRect = %EnemyHighlightScreen
@onready var death_menu: CanvasLayer = %DeathMenu
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var stats: VBoxContainer = $DeathMenu/Controls/Stats
@onready var retry_button: Button = $DeathMenu/Controls/HBoxContainer/RetryButton

var enemy: Enemy

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


func _on_submit_score_pressed() -> void:
	GameManager.get_stats_man().submit.emit()
