extends Node

@onready var fade_to_black: ColorRect = %FadeToBlack
@onready var death_menu: CanvasLayer = %DeathMenu
@onready var title: HBoxContainer = %Title
@onready var death_text: Label = %DeathText
@onready var buttons: VBoxContainer = %Buttons
@onready var timer: Timer = %Timer
@onready var type_sfx: AudioStreamPlayer2D = %TypeSFX
@onready var reveal_sfx: AudioStreamPlayer2D = %RevealSFX
@onready var skull_1_1: TextureRect = %"DeathMenu/PauseMenuWrapper/VBoxContainer/Title/Skull1-1"
@onready var skull_1_2: TextureRect = %"DeathMenu/PauseMenuWrapper/VBoxContainer/Title/Skull1-2"
@onready var skull_2_2: TextureRect = $"DeathMenu/PauseMenuWrapper/VBoxContainer/Title/Skull2-2"
@onready var skull_2_1: TextureRect = $"DeathMenu/PauseMenuWrapper/VBoxContainer/Title/Skull2-1"


var enemy: Enemy
var visibility: float = 0.0

var death_text_text = "Billy Bob was unable to reclaim his bottle. Soon after the minions of C'thulhu stormed the land. All reality, namely the moonshine bottle, was torn apart by C'thulhu's presence"
var death_text_index = 0
var death_text_done = false

var timer_started = false
var skulls_animate = false
var skulls_animate_speed = 0.1
var skulls_time_since = skulls_animate_speed

func toggle_skulls() -> void:
	if skull_1_1.visible:
		skull_1_1.visible = false
		skull_2_1.visible = false
		skull_1_2.visible = true
		skull_2_2.visible = true
	else:
		skull_1_1.visible = true
		skull_2_1.visible = true
		skull_1_2.visible = false
		skull_2_2.visible = false
		
func reset_skulls() -> void:
	skull_1_1.visible = true
	skull_2_1.visible = true
	skull_1_2.visible = false
	skull_2_2.visible = false

func initialize(enemy: Enemy) -> void:
	self.enemy = enemy
	self.enemy.enemy_base.sprite_2d.z_index = 2

func _ready() -> void:
	GameManager.pause(self)
	GameManager._player.level_switcher.stop_music()
	reset_skulls()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		skulls_animate = false
		reset_skulls()
		visibility = 0.9
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
		
	if visibility < 0.9:
		visibility += delta
		fade_to_black.color.a = visibility
		GameManager._player.hud_modulate.color.a = 1.0 - visibility
	elif not timer_started:
		visibility = 0.9
		timer_started = true
		timer.start()
		timer.wait_time = 1
	
	if skulls_animate:
		if skulls_time_since > skulls_animate_speed:
			skulls_time_since = 0
			toggle_skulls()
		else:
			skulls_time_since += delta


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
		skulls_animate = true
		type_sfx.play()
		death_text.text += death_text_text[death_text_index]
		death_text_index += 1
	elif not death_text_done:
		skulls_animate = false
		death_text_done = true
		timer.wait_time = 1
		reset_skulls()
	elif not buttons.visible:
		reveal_sfx.play()
		buttons.visible = true
		timer.stop()
