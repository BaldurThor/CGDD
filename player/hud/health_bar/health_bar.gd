class_name HealthBar extends ProgressBar
@export var stat_manager_path: NodePath

var stats_node: StatManager

func _ready() -> void:
	_setup.call_deferred()

func _setup():
	stats_node = get_node(stat_manager_path)
	stats_node.stats.health_changed.connect(_update_health_visuals)
	stats_node.stats.max_health_changed.connect(_update_health_visuals)
	max_value = stats_node.stats.max_health
	step = 1
	value = stats_node.stats.health

func _update_health_visuals(_new_health: int, _change: int):
	max_value = stats_node.stats.max_health
	value = stats_node.stats.health
