@tool
@icon("res://player/player_stats_icon.svg")
class_name PlayerStats extends EntityStats

## Integer stats
@export_category("Flat Stats")
## A flat bonus to the number of projectiles fired by the player's ranged weapons.
@export_range(0, 2, 1, "or_greater") var extra_projectiles: int = 0 # linear additive
## A flat amount of health healed by the player every time the regen timer ticks.
@export_range(0, 100, 1, "or_greater") var regen_amount: int = 0

## Floating-point stats
@export_category("Decimal Stats")
## The chance of the player completely ignoring damage from a single attack. Grants invincibility frames.
@export_range(0.0, 0.75, 0.01) var dodge_chance: float = 0.0 # linear
## The chance of a single projectile of an attack (NOT the entire attack unless it's melee) getting a critical multiplier.
@export_range(0.0, 1.0, 0.01) var crit_chance: float = 0.0 # linear
## A multiplier to attacks that crit.
@export_range(1.0, 3.0, 0.01) var crit_multiplier: float = 1.0
## The "accuracy" of the player's weapons. Affects bullet velocity (and therefore range)
@export_range(0.5, 3.0, 0.01, "or_greater") var accuracy: float = 1.0
## The number of seconds it takes for each regen tick.
@export_range(0.1, 100.0, 0.1, "or_greater") var regen_speed: float = 1.0

## Multipliers which affect other stats but are not stats in themselves.
@export_category("Multipliers")
## A multiplier to a melee attack or a single projectile's damage.
@export var damage: float = 1.0 # linear
## A multiplier to the player's maximum health. Increasing this value should heal the player by the modified amount.
@export var max_health_mod: float = 1.0
@export var regen_speed_mod: float = 1.0
