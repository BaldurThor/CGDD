extends Sprite2D

@onready var firearm: Firearm = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.texture = firearm.weapon_type.crosshair
