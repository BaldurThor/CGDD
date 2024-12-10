class_name OrbitalMeleeWeapon extends Area2D

@onready var damage_calculation: MeleeDamageCalculation = $"../../MeleeDamageCalculation"

func _on_body_entered(body: Node) -> void:
	if body is Enemy:
		body.take_damage(damage_calculation.calculate_damage(), damage_calculation.calculate_knockback(), global_position)
