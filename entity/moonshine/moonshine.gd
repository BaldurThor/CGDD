@tool
extends Area2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var pickup_sfx: AudioStreamPlayer = $AudioStreamPlayer
@onready var shadow: Sprite2D = $Shadow

@export var float_distance: float = 10.0
@export var float_speed: float = 10.0
@export var float_offset: Vector2 = Vector2.ZERO

var timer: float = 0.0
var velocity: Vector2 = Vector2.ZERO
var gravity_active: bool = false

func _enter_tree() -> void:
	GameManager.freeze_enemies = true

func _process(delta: float) -> void:
	timer += delta
	
	if not gravity_active:
		sprite_2d.position.y = sin(timer * float_speed) * float_distance + float_offset.y
		sprite_2d.position.x = float_offset.x
		return
		
	velocity += Vector2.DOWN * 980 * delta
	sprite_2d.position += velocity * delta

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		GameManager.game_win.emit()
		pickup_sfx.play()
		var tween = get_tree().create_tween()
		tween.tween_property(sprite_2d, "modulate", Color.TRANSPARENT, 0.3)
		tween.tween_property(shadow, "modulate", Color.TRANSPARENT, 0.3)
		tween.tween_callback(queue_free)
		gravity_active = true
		velocity = Vector2.UP * 200
		body.freeze_player = true
