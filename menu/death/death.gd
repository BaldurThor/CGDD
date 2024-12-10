extends Node

@onready var fade_to_black: ColorRect = %FadeToBlack
@onready var death_menu: CanvasLayer = %DeathMenu

var enemy: Enemy
var visibility: float = 0.0

func initialize(enemy: Enemy) -> void:
	self.enemy = enemy
	self.enemy.z_index = 2

func _ready() -> void:
	GameManager.pause(self)

func _process(delta: float) -> void:
	if visibility <= 1.0:
		visibility += delta
		fade_to_black.color.a = visibility
		GameManager._player.hud_mod.color.a = 1.0 - visibility
	elif not death_menu.visible:
		death_menu.visible = true
