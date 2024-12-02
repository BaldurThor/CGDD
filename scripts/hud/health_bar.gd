class_name HealthBar extends ProgressBar
@export var health_node_path: NodePath

var health_node: EntityHealth

func _ready() -> void:
	health_node = get_node(health_node_path)
	health_node.health_changed.connect(_update_health_visuals)
	max_value = health_node.max_health
	step = 1
	value = health_node.health

func _update_health_visuals(new_health: int, _change: int):
	value = new_health
