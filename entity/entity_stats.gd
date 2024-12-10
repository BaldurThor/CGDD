@tool
@icon("res://player/player_stats_icon.svg")
class_name EntityStats extends Node

# This Node contains all stats that are shared between the player and entities (enemies).
# If you intend to add a new stat, do NOT add it here unless applicable. If it is
# a stat for the player, change PlayerStats instead.


signal health_changed(new_health: int, change: int)
signal max_health_changed(new_max_health: int, change: int)
signal regen_changed()
signal death()
signal take_damage(raw_amount: int)

var is_invincible: bool = false

@export_category("Stats")

# @export_group("Offense") unused at the moment. Re-enable if needed

@export_group("Defense")

## The entity's armor (damage reduction)
@export var armor: int

## The amount of damage this entity can take before dying.
@export var max_health: int:
	set(value):
		var current_max: int = get_real_max_health()
		# Edge-case where max health is 0 during initialization
		if current_max == 0:
			max_health = value
			return
		if value > max_health:
			# If the entity's max health increased, heal it to keep the health : max health ratio
			max_health = max(1, value)
			health += max_health - current_max
		else:
			# If the entity's max health decreased, clamp its current health to its max health.
			max_health = max(1, value)
			health = min(health, get_real_max_health())
		health_changed.emit()

# WARNING: DO NOT PUT HEALTH ABOVE MAX_HEALTH. max_health needs to initialize first
# otherwise health will be clamped between 0 and 0 during initialization.

## The entity's current health
@export var health: int:
	set(value):
		health = clamp(value, 0, get_real_max_health())
		health_changed.emit()
		
		if health <= 0:
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
## A multiplier to the entity's regeneration speed. Increasing this value will make the regen tick faster.
@export_range(0.0, 3.0, 0.1) var regen_speed_mod: float = 1.0:
	set(value):
		regen_speed_mod = value
		regen_changed.emit()

## A multiplier to all knockback received by this entity. Higher values cause in higher knockback received.
@export_range(0.0, 2.0, 0.01) var self_knockback_mod: float = 1.0

@onready var invincibility_timer: Timer = $InvincibilityTimer
@onready var regen_timer: Timer = $RegenTimer


func _on_invincibility_timer_timeout() -> void:
	is_invincible = false

func deal_damage(amount: int) -> void:
	if health <= 0:
		return
	
	take_damage.emit(amount)
	
	var dmg_modified = get_damage_applied(amount)
	health -= dmg_modified
	health_changed.emit()
	
	if invincibility_time > 0.0:
		is_invincible = true
		invincibility_timer.wait_time = invincibility_time
		invincibility_timer.start()

func get_damage_applied(amount: int) -> float:
	return amount * damage_reduction()

func damage_reduction() -> float:
	return calculate_damage_reduction(armor)

func get_real_max_health() -> int:
	return max_health

func get_health_percentage() -> float:
	return float(health) / get_real_max_health()

func calculate_damage_reduction(armor_value: int) -> float:
	var a: float = (-1.0 + armor) / (4 * armor)
	var b: float = (log(armor) / log(2)) / 10
	return max(a + b, 1)
