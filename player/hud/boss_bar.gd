extends ProgressBar

@onready var boss_title: Label = $"../BossTitle"
@onready var boss_bar_wrapper: Control = $".."

var _active_boss: Boss

func _ready() -> void:
	GameManager.boss_spawned.connect(_on_boss_spawned)

func _on_boss_spawned(boss: Boss) -> void:
	_active_boss = boss
	boss_title.text = boss.boss_title

func _process(_delta: float) -> void:
	boss_bar_wrapper.visible = _active_boss != null
	
	if _active_boss == null:
		return
		
	value = _active_boss.entity_stats.health
	max_value = _active_boss.entity_stats.max_health
