class_name SpikeImpactBehavior extends Node

@onready var spike: Spike = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spike.body_entered.connect(_handle_impact)
	spike.enemy.entity_stats.death.connect(queue_free)

func _handle_impact(collided_with: Node2D) -> void:
	if collided_with is Player:
		if collided_with.player_stats.get_health_percentage() <= 0.0:
			return
		collided_with.take_damage(spike.calculate_damage(), spike.enemy)
		spike.despawn.emit()

func _on_timeout() -> void:
	spike.despawn.emit()
