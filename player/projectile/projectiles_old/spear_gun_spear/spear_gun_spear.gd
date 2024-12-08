class_name SpearGunSpear extends Bullet

@onready var sprite: Sprite2D = $Sprite

func _ready() -> void:
	# Force the sprite to rotate in the direction it is launched in.
	# Prevents the sprite from being static and looking as if the sharp bit isn't
	# hitting the target due to it inherently facing right.
	sprite.look_at(direction)
