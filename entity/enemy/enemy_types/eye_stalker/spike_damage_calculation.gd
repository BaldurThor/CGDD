class_name SpikeDamageCalculation extends Node

@onready var spike: Spike = $".."

func calculate_damage() -> int:
	return max(1, int(spike.damage_on_hit))
