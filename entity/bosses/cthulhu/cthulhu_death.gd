extends GPUParticles2D

const SHOCKWAVE = preload("res://levels/transition/shockwave.tscn")

var _emit_shockwaves: bool = true

func _ready() -> void:
	emitting = true

func _on_timer_timeout() -> void:
	queue_free()

func _spawn(scene: PackedScene):
	var spawned = scene.instantiate()
	GameManager.get_game_root().add_child(spawned)
	spawned.global_position = global_position

func _on_shockwave_timer_timeout() -> void:
	if _emit_shockwaves:
		_spawn(SHOCKWAVE)

func _on_shockwave_stop_timer_timeout() -> void:
	_emit_shockwaves = false
