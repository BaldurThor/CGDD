extends Node

@onready var fade_to_black: ColorRect = %FadeToBlack
@onready var death_menu: CanvasLayer = %DeathMenu
@onready var title: HBoxContainer = %Title
@onready var death_text: Label = %DeathText
@onready var buttons: VBoxContainer = %Buttons
@onready var timer: Timer = %Timer
@onready var type_sfx: AudioStreamPlayer2D = %TypeSFX
@onready var reveal_sfx: AudioStreamPlayer2D = %RevealSFX

var enemy: Enemy
var visibility: float = 0.0

var death_text_text = "Billy Bob was unable to reclaim his bottle. Soon after the minions of C'thulhu stormed the land. All reality, namely the moonshine bottle, was torn apart by Cthulhu's presence"
var death_text_index = 0
var death_text_done = false

var timer_started = false

func initialize(enemy: Enemy) -> void:
	self.enemy = enemy
	self.enemy.enemy_base.sprite_2d.z_index = 2

func _ready() -> void:
	GameManager.pause(self)
	GameManager._player.level_switcher.stop_music()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		visibility = 1.0
		fade_to_black.color.a = visibility
		GameManager._player.hud_modulate.color.a = 1.0 - visibility
		death_menu.visible = true
		title.visible = true
		death_text.visible = true
		while death_text_index != death_text_text.length():
			death_text.text += death_text_text[death_text_index]
			death_text_index += 1
		death_text_done = true
		buttons.visible = true
		timer.stop()
		timer_started = true
		
	if visibility < 1.0:
		visibility += delta
		fade_to_black.color.a = visibility
		GameManager._player.hud_modulate.color.a = 1.0 - visibility
	elif not timer_started:
		timer_started = true
		timer.start()


func _on_sec_timer_timeout() -> void:
	if not death_menu.visible:
		reveal_sfx.play()
		death_menu.visible = true
	elif not title.visible:
		reveal_sfx.play()
		title.visible = true
	elif not death_text.visible:
		death_text.visible = true
		timer.wait_time = 0.05
	elif death_text_index != death_text_text.length():
		type_sfx.play()
		death_text.text += death_text_text[death_text_index]
		death_text_index += 1
	elif not death_text_done:
		death_text_done = true
		timer.wait_time = 1
	elif not buttons.visible:
		reveal_sfx.play()
		buttons.visible = true
		timer.stop()
