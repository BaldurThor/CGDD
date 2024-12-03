@tool
@icon("res://player/player_stats_icon.svg")
class_name EntityStats extends Node

# This Node contains all stats that are shared between the player and entities (enemies).
# If you intend to add a new stat, do NOT add it here unless applicable. If it is
# a stat for the player, change PlayerStats instead.


signal health_changed(new_health: int, change: int)
signal max_health_changed(new_max_health: int, change: int)
signal death
signal take_damage(raw_amount: int)

var is_invincible: bool = false

@export_category("Stats")

@export_group("Offense")

## The entity's armor (damage reduction)
@export var armor: int

@export_group("Defense")

## The amount of damage this entity can take before dying.
@export var max_health: int:
	set(value):
		var delta = max_health - value
		max_health = max(1, value)
		health_changed.emit(value, delta)
		health = min(value, health)

# WARNING: DO NOT PUT HEALTH ABOVE MAX_HEALTH. max_health needs to initialize first
# otherwise health will be clamped between 0 and 0 during initialization.

## The entity's current health
@export var health: int:
	set(value):
		var delta = health - value
		health = clamp(value, 0, max_health)
		health_changed.emit(value, delta)
		
		if health == 0:
			death.emit()

## The entity's movement speed.
@export var movement_speed: float
## The damage dealt to opposing entities on contact
@export var contact_damage: int = 0

## The number of seconds where the player is granted damage immunity on taking damage
@export_range(0, 2, 0.1, "or_greater") var invincibility_time: float = 0.25

@export_category("Multipliers")

@export_group("Offense")

## The entity's attack speed modifier.
@export var attack_speed_mod: float = 1.0

@export_group("Defense")

@onready var invincibility_timer: Timer = $InvincibilityTimer


func _on_invincibility_timer_timeout() -> void:
	is_invincible = false

func deal_damage(amount: int):
	take_damage.emit(amount)
	
	var dmg_modified = amount * damage_reduction()
	health -= dmg_modified
	health_changed.emit(health, dmg_modified)
	
	if invincibility_time > 0.0:
		is_invincible = true
		invincibility_timer.wait_time = invincibility_time
		invincibility_timer.start()

func damage_reduction() -> float:
	var a: float = (-1.0 + armor) / (4 * armor)
	var b: float = (log(armor) / log(2)) / 10
	return max(a + b, 1)
