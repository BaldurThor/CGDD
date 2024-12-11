class_name MeleeSwivel extends Node2D

signal target_acquired()

var weapon_type: WeaponType = null
var player_stats: PlayerStats = null
var enemy: Enemy = null

@onready var melee: Melee = $".."
@onready var crosshair: Sprite2D = $"../Crosshair"

func _ready() -> void:
	self.weapon_type = melee.weapon_type
	self.player_stats = melee.player_stats

func _process(_delta: float) -> void:
	enemy = melee.weapon_group.request_target(melee.index_in_group)
	if enemy != null:
		look_at(enemy.position)
		target_acquired.emit()
		crosshair.visible = true
		crosshair.global_position = enemy.position
	elif crosshair.visible:
		crosshair.visible = false
