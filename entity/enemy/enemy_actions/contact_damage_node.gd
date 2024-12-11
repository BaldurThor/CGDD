class_name ContactDamageNode extends LogicNode

@export var enemy: Enemy
@export var damage_zone: Area2D

func evaluate() -> bool:
	return false

func _physics_process(_delta: float) -> void:
	for body in damage_zone.get_overlapping_bodies():
		if body is Player:
			body.take_damage(enemy.entity_stats.contact_damage, enemy)
