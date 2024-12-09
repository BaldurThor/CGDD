extends Sprite2D

@onready var weapon: Node2D = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.texture = weapon.weapon_type.crosshair
