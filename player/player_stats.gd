@icon("res://player/player_stats_icon.svg")
class_name PlayerStats extends Node

@export_category("Base Stats")
@export var speed: float = 300.0 # logarithmic scale
@export_range(0, 0.75, 0.01) var dodge_chance: float = 0.0 # linear
@export_range(0, 3, 0.01) var crit_chance: float = 0.0 # linear
@export_range(0, 2, 1, "or_greater") var extra_projectiles = 0 # linear addative

@export_category("Stat Multipliers")
@export var damage: float = 1 # linear
@export var attack_speed: float = 1 # linear
