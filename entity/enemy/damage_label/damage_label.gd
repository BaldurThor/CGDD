extends Label

var visibility: float = 1.0
var drift: Vector2
var damage = 0
var max_health = 1

func initialize(position: Vector2, damage: int, max_health: int) -> void:
	self.damage = damage
	self.max_health = max_health
	self.update_helper(position)
	
func update(position: Vector2, damage: int) -> void:
	self.damage += damage
	self.visibility = 1.0
	self.update_helper(position)
	
func update_helper(position: Vector2) -> void:
	self.position = position
	self.position.x -= 5
	self.position.y -= 40
	drift = Vector2(randf_range(-1.0, 1.0), -1.0)
	# make it so lower numbers are white and high numbers are red, idk how though
	self.modulate.g = remap(self.damage, 1, self.max_health, 1, 0)
	self.modulate.b = remap(self.damage, 1, self.max_health, 1, 0)
	
	self.text = str(self.damage)

func _process(delta: float) -> void:
	#self.position += drift * delta * 25
	if visibility <= 0.01:
		self.queue_free()
	visibility -= delta
	self.self_modulate.a = visibility
