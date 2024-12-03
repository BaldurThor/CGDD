@tool
@icon("res://entity/entity_health_icon.svg")
class_name EntityHealth extends Node

@export var max_health: int = 10:
	set(value):
		var delta = max_health - value
		max_health = max(1, value)
		health_changed.emit(value, delta)
		health = min(value, health)

@export var health: int = 10:
	set(value):
		var delta = health - value
		health = clamp(value, 0, max_health)
		
		if health == 0:
			death.emit()
		else:
			health_changed.emit(value, delta)

@export var armor: int = 1 # logarithmic scale
@export var invincibility_time: float = 0.25

var is_invincible: bool = false

signal health_changed(new_health: int, change: int)
signal max_health_changed(new_max_health: int, change: int)
signal death

func deal_damage(amount: int) -> void:
	if is_invincible:
		return
	
	is_invincible = true
	health = health - amount
	
	await get_tree().create_timer(invincibility_time).timeout
	is_invincible = false
