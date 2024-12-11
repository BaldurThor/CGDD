extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_delay: Timer = $AttackDelay
@onready var attack_sound: AudioStreamPlayer2D = $AttackSound

@export var damage: int = 5

var enemy: Enemy

func init(
	_bullet_direction: Vector2,
	owning_enemy: Enemy,
	_despawn_time: float,
	_starting_speed: float,
	_final_speed: float,
) -> void:
	enemy = owning_enemy

func _ready() -> void:
	attack_delay.timeout.connect(_attack)

func _attack() -> void:
	animated_sprite_2d.play("attack")
	attack_sound.play()
	
	for entity in get_overlapping_bodies():
		if entity is Player:
			entity.take_damage(damage, enemy)
	
	await animated_sprite_2d.animation_finished
	queue_free()
