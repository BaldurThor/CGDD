extends ProgressBar

var _active_boss: Boss

func _ready() -> void:
	GameManager.boss_spawned.connect(_on_boss_spawned)

func _on_boss_spawned(boss: Boss) -> void:
	_active_boss = boss

func _process(delta: float) -> void:
	visible = _active_boss != null
	
	if _active_boss == null:
		return
	
	value = _active_boss.entity_stats.health
	max_value = _active_boss.entity_stats.max_health
