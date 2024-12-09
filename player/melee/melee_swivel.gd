class_name MeleeSwivel extends Node2D

signal target_acquired()

var weapon_type: WeaponType = null
var player_stats: PlayerStats = null
var enemy: Enemy = null

@onready var melee: Melee = $".."
@onready var _melee_target_range: MeleeTargetRange = $MeleeWeapon/MeleeTargetRange
@onready var crosshair: Sprite2D = $"../Crosshair"

func _ready() -> void:
	self.weapon_type = melee.weapon_type
	self.player_stats = melee.player_stats

func _process(_delta: float) -> void:
	enemy = _melee_target_range.get_target()
	if enemy != null:
		look_at(enemy.position)
		target_acquired.emit()
		crosshair.visible = true
		crosshair.global_position = enemy.position
	elif crosshair.visible:
		crosshair.visible = false
