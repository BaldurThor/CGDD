class_name TargetRange extends Area2D

# This object handles the attack radius for weapons.
# NOTE: WARNING: ENSURE THAT THE SHAPE IS LOCAL TO THE SCENE!!!
# If it is not, all changes to any weapon's radius will reflect to the same, single instance.

@onready var target_range_shape: CollisionShape2D = $TargetRangeShape
@onready var gun_swivel: GunSwivel = $"../GunSwivel"

var current_target: Enemy

func _ready() -> void:
	_on_player_stats_range_changed()
	gun_swivel.player_stats.range_changed.connect(_on_player_stats_range_changed)
	target_range_shape.debug_color = gun_swivel.weapon_type.attack_range_debug_color

## Signal receiver which handles any changes to the weapon's accuracy.
## NOTE: If weapon-specific scaling is ever added, this must be updated.
func _on_player_stats_range_changed() -> void:
	target_range_shape.shape.radius = gun_swivel.weapon_type.range * gun_swivel.player_stats.ranged_accuracy_mod

## Retrieves a single enemy based on the weapon type's target priority.
func get_target() -> Enemy:
	# NOTE: This is how you assign a stricter type to an array of Node2D.
	var targets: Array[Enemy]
	targets.assign(get_overlapping_bodies())
	if targets.size() == 0:
		return null
	match gun_swivel.weapon_type.target_priority:
		consts.TargetPriority.CLOSEST:
			_target_closest(targets)
		consts.TargetPriority.FARTHEST:
			_target_farthest(targets)
		consts.TargetPriority.RANDOM:
			targets.pick_random()
		consts.TargetPriority.STRONGEST:
			_target_strongest(targets)
		consts.TargetPriority.WEAKEST:
			_target_weakest(targets)
		_:
			return null
	return current_target

## Returns the closest enemy to the origin of the range.
func _target_closest(targets: Array[Enemy]) -> void:
	_order_targets_by_distance(targets)
	current_target = targets[0]

## Returns the farthest enemy from the origin of the range.
func _target_farthest(targets: Array[Enemy]):
	_order_targets_by_distance(targets)
	current_target = targets[targets.size() - 1]

## Returns the enemy with the lowest % health in the range.
func _target_weakest(targets: Array[Enemy]) -> void:
	_order_targets_by_strength(targets)
	current_target = targets[0]

## Returns the enemy with the highest % health in the range.
func _target_strongest(targets: Array[Enemy]) -> void:
	_order_targets_by_strength(targets)
	current_target = targets[targets.size() - 1]

## Modifies the provided array (reference), sorting it by the enemy distance in an ascending order.
func _order_targets_by_distance(targets: Array[Enemy]) -> void:
	targets.sort_custom(func(a, b): return a.distance_to_player < b.distance_to_player)

## Modifies the provided array (reference), sorting it by the enemy health % in an ascending order.
func _order_targets_by_strength(targets: Array[Enemy]) -> void:
	targets.sort_custom(func(a, b): return a.entity_stats.get_health_percentage() < b.entity_stats.get_health_percentage())
