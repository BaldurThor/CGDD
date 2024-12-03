@icon("res://player/player_stats_icon.svg")
class_name StatManager extends Node

@export var stats: EntityStats
@onready var invincibility_timer: Timer = $InvincibilityTimer

signal take_damage(raw_amount: int)

func _ready() -> void:
	take_damage.connect(_on_damage_taken)

func _on_invincibility_timer_timeout() -> void:
	stats.is_invincible = false

func _take_damage(amount: int) -> void:
	var dmg_modified = amount * stats.damage_reduction()
	stats.health -= dmg_modified
	stats.health_changed.emit(stats.health, dmg_modified)


func _on_damage_taken(raw_amount: int) -> void:
	_take_damage(raw_amount)
	if stats.invincibility_time > 0.0:
		stats.is_invincible = true
		invincibility_timer.wait_time = stats.invincibility_time
		invincibility_timer.start()
