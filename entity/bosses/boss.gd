class_name Boss extends Enemy

func _ready() -> void:
	GameManager.add_boss(self)
	entity_stats.death.connect(_on_death)

func _on_death() -> void:
	GameManager.boss_killed.emit(self)
