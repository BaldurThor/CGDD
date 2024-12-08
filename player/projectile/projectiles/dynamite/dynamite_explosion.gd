extends Area2D

var _damage: int

@onready var explosion_animation: AnimationPlayer = $ExplosionAnimation
@onready var explosion_sound_effect: AudioStreamPlayer2D = $ExplosionSoundEffect

func init(_weapon: WeaponType, _stats: PlayerStats, damage: int) -> void:
	_damage = damage
	
func _ready() -> void:
	# I hate this
	await get_tree().create_timer(0.05).timeout
	_explode()

func _explode() -> void:
	var nearby_enemies = get_overlapping_bodies()
	# Randomly pitch the sound effect up/down to add variety.
	explosion_sound_effect.pitch_scale = randf_range(0.8, 1.2)
	explosion_animation.play("explode")
	GameManager.explosion_occurred.emit()
	for enemy in nearby_enemies:
		if enemy is Enemy:
			enemy.take_damage(_damage)
