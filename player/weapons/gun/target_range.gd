class_name TargetRange extends Area2D

# This object handles the attack radius for weapons.
# NOTE: WARNING: ENSURE THAT THE SHAPE IS LOCAL TO THE SCENE!!!
# If it is not, all changes to any weapon's radius will reflect to the same, single instance.

@onready var target_range_shape: CollisionShape2D = $TargetRangeShape
@onready var weapon_group: WeaponGroup = $".."

var current_target: Enemy

## Retrieves a single enemy based on the weapon type's target priority.
func get_targets() -> Array[Enemy]:
	# NOTE: This is how you assign a stricter type to an array of Node2D.
	var targets: Array[Enemy]
	targets.assign(get_overlapping_bodies())

	match weapon_group.weapon_type.target_priority:
		consts.TargetPriority.CLOSEST: _closest(targets)
		consts.TargetPriority.FARTHEST: _farthest(targets)
		consts.TargetPriority.RANDOM: targets.shuffle()
		consts.TargetPriority.STRONGEST: _strongest(targets)
		consts.TargetPriority.WEAKEST: _weakest(targets)
	return targets

## Returns the closest enemy to the origin of the range.
func _closest(targets: Array[Enemy]) -> void:
	_order_targets_by_distance(targets)

## Returns the farthest enemy from the origin of the range.
func _farthest(targets: Array[Enemy]):
	_order_targets_by_distance(targets)
	targets.reverse()

## Returns the enemy with the lowest % health in the range.
func _weakest(targets: Array[Enemy]) -> void:
	_order_targets_by_strength(targets)

## Returns the enemy with the highest % health in the range.
func _strongest(targets: Array[Enemy]) -> void:
	_order_targets_by_strength(targets)
	targets.reverse()

## Modifies the provided array (reference), sorting it by the enemy distance in an ascending order.
func _order_targets_by_distance(targets: Array[Enemy]) -> void:
	targets.sort_custom(func(a, b): return a.distance_to_player < b.distance_to_player)

## Modifies the provided array (reference), sorting it by the enemy health % in an ascending order.
func _order_targets_by_strength(targets: Array[Enemy]) -> void:
	targets.sort_custom(func(a, b): return a.entity_stats.get_health_percentage() < b.entity_stats.get_health_percentage())
