extends Label

var visibility: float = 1.0
var drift: Vector2
var damage = 0
var max_health = 1

func initialize(pos: Vector2, dmg: int, maximum_health: int) -> void:
	damage = dmg
	max_health = maximum_health
	update_helper(pos)
	
func update(pos: Vector2, dmg: int) -> void:
	damage += dmg
	visibility = 1.0
	update_helper(pos)
	
func update_helper(pos: Vector2) -> void:
	position = pos
	position.x -= 5
	position.y -= 40
	drift = Vector2(randf_range(-1.0, 1.0), -1.0)
	# make it so lower numbers are white and high numbers are red, idk how though
	modulate.g = remap(damage, 1, max_health, 1, 0)
	modulate.b = remap(damage, 1, max_health, 1, 0)
	
	text = str(damage)

func _process(delta: float) -> void:
	#self.position += drift * delta * 25
	if visibility <= 0.01:
		queue_free()
	visibility -= delta
	self_modulate.a = visibility
