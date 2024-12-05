class_name HealthBar extends ProgressBar

@export var stats_node: EntityStats

func _ready() -> void:
	_setup.call_deferred()

func _setup():
	stats_node.health_changed.connect(_update_health_visuals)
	stats_node.max_health_changed.connect(_update_health_visuals)
	max_value = stats_node.get_real_max_health()
	step = 1
	value = stats_node.health

func _update_health_visuals() -> void:
	max_value = stats_node.get_real_max_health()
	value = stats_node.health
