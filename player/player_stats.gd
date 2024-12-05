@tool
@icon("res://player/player_stats_icon.svg")
class_name PlayerStats extends EntityStats

@export_category("Stats")

@export_group("Offense - Ranged")

## A flat amount of bonus damage to all projectiles fired by ranged weapons.
@export_range(0, 10, 1, "or_greater") var added_ranged_damage: int = 0

## A flat bonus to the number of projectiles fired by the player's ranged weapons.
@export_range(0, 2, 1, "or_greater") var extra_projectiles: int = 0 # linear additive

## The number of times a projectile can pass through an entity before despawning (additive with weapon/projectile modifiers).
@export_range(0, 3, 1, "or_greater") var extra_projectile_pierce: int = 0

@export_group("Offense - General")

## The chance of a single projectile of an attack (NOT the entire attack unless it's melee) getting a critical multiplier.
@export_range(0.0, 1.0, 0.01) var crit_chance: float = 0.0 # linear

@export_group("Defense")

## A flat amount of health healed by the player every time the regen timer ticks.
@export_range(0, 100, 1, "or_greater") var regen_amount_flat: int = 0
## A percentile amount of health healed by the player every time the regen timer ticks.
@export_range(0.0, 100.0, 0.1) var regen_amount_percentile: float = 0.0

## The chance of the player completely ignoring damage from a single attack. Grants invincibility frames.
@export_range(0.0, 0.75, 0.01) var dodge_chance: float = 0.0 # linear

## The number of seconds it takes for each regen tick.
@export_range(0.1, 100.0, 0.1, "or_greater") var regen_speed: float = 1.0

## Multipliers which affect other stats but are not stats in themselves.
@export_category("Multipliers")

@export_group("Offense - Ranged")

## The "accuracy" of the player's weapons. Affects bullet velocity (and therefore range)
@export_range(0.5, 3.0, 0.01, "or_greater") var ranged_accuracy_mod: float = 1.0

## Affects the spread of the player's ranged projectiles. A lower value means higher spread.
@export_range(0.0, 2.0, 0.01, "or_greater") var ranged_spread_mod: float = 0.0

## A multiplier to the attack speed of all ranged weapons.
@export_range(0.5, 3.0, 0.01, "or_greater") var ranged_attack_speed_mod: float = 1.0

@export_group("Offense - General")

## A multiplier to a melee attack or a single projectile's damage.
@export var damage_mod: float = 1.0 # linear

## A multiplier to attacks that crit.
@export_range(1.0, 3.0, 0.01) var crit_multiplier: float = 1.0

@export_group("Defense")

## A multiplier to the player's maximum health. Increasing this value should heal the player by the modified amount.
@export var max_health_mod: float = 1.0:
	set(value):
		var curr_percentage = float(health) / get_real_max_health()
		max_health_mod = value
		# No need to emit the signal in this setter, as health calls health_updated
		health = get_real_max_health * curr_percentage

## A multiplier to the player's regeneration speed. Increasing this value will make the player regenerate health faster.
@export_range(0.0, 3.0, 0.1) var regen_speed_mod: float = 1.0

@export_category("Other")
## Whether the player can regenerate or not. If false, regen cannot affect the player at all.
@export var can_regen: bool = true

## Evaluates the player's max health. Always returns a value equal to or greater than 1.
func get_real_max_health() -> int:
	var base = super()
	return int(max(base * max_health_mod, 1))
