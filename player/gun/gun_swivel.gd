class_name GunSwivel extends Node2D

signal target_acquired()

var weapon_type: WeaponType = null
var player_stats: PlayerStats = null
var enemy: Enemy = null

@onready var _target_range: TargetRange = $"../TargetRange"
@onready var firearm: Firearm = $".."

func _ready() -> void:
	self.weapon_type = firearm.weapon_type
	self.player_stats = firearm.player_stats

func _process(_delta: float) -> void:
	enemy = _target_range.get_target()
	if enemy != null:
		look_at(enemy.position)
		target_acquired.emit()
