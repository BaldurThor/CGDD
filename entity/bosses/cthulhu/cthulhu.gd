class_name Cthulhu extends Boss

const MOONSHINE = preload("res://entity/moonshine/moonshine.tscn")
const SHOCKWAVE = preload("res://levels/transition/shockwave.tscn")
const CTHULHU_DEATH = preload("res://entity/bosses/cthulhu/cthulhu_death.tscn")

func _on_death() -> void:
	super()
	_spawn(MOONSHINE)
	_spawn(CTHULHU_DEATH)

func _spawn(scene: PackedScene):
	var spawned = scene.instantiate()
	GameManager.get_game_root().add_child.call_deferred(spawned)
	spawned.global_position = global_position
