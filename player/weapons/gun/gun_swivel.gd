class_name GunSwivel extends Node2D

signal target_acquired()

var weapon_type: WeaponType = null
var player_stats: PlayerStats = null
var enemy: Enemy = null

@onready var firearm: Firearm = $".."
@onready var crosshair: Sprite2D = $"../Crosshair"

func _ready() -> void:
	self.weapon_type = firearm.weapon_type
	self.player_stats = firearm.player_stats

func _process(_delta: float) -> void:
	enemy = firearm.weapon_group.request_target(firearm.index_in_group)
	if enemy != null:
		look_at(enemy.position)
		target_acquired.emit()
		crosshair.visible = true
		crosshair.global_position = enemy.position
	elif crosshair.visible:
		crosshair.visible = false
