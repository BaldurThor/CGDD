extends Area2D

func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2.ONE * 2, 2.0).set_ease(Tween.EASE_OUT)
	tween.tween_callback(queue_free)

func _on_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.take_damage(1000, 0, Vector2.ZERO, false)
