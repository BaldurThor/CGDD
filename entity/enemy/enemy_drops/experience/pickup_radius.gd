class_name PickupRange extends Area2D

## The radius at which the gems are drawn towards the player.
## This radius may be changed at runtime.

@onready var player_stats: PlayerStats = %PlayerStats
@onready var absorb_radius_shape: CollisionShape2D = $AbsorbRadiusShape

func _ready() -> void:
	_evaluate_radius()

func _on_body_entered(body: Node2D) -> void:
	if body is PickupBase:
		body.start_tracking_player()

func _evaluate_radius() -> void:
	var new_radius = player_stats.item_absorb_range * player_stats.item_absorb_range_mod
	absorb_radius_shape.shape.radius = new_radius


func _on_player_stats_item_absorb_range_changed() -> void:
	_evaluate_radius()
