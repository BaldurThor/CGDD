extends Label

var visibility: float = 1.0
var drift: Vector2

func initialize(start_position: Vector2, damage: int) -> void:
	self.position = start_position
	self.position.x -= 5
	self.position.y -= 40
	drift = Vector2(randf_range(-1.0, 1.0), -1.0)
	# make it so lower numbers are white and high numbers are red, idk how though
	self.text = str(damage)

func _process(delta: float) -> void:
	self.position += drift * delta * 25
	if visibility <= 0.01:
		self.queue_free()
	visibility -= delta
	self.self_modulate.a = visibility
