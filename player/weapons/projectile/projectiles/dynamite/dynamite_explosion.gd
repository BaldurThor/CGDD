class_name DynamiteExplosion extends Area2D

@onready var explosion_animation: AnimationPlayer = $ExplosionAnimation
@onready var explosion_sound_effect: AudioStreamPlayer2D = $ExplosionSoundEffect
@onready var damage_calculation: ExplosionDamageCalculation = $DamageCalculation
@onready var explosion_radius: CollisionShape2D = $ExplosionRadius

const CRATER = preload("res://player/weapons/projectile/crater.tscn")

var weapon_group: WeaponGroup = null

func init(group: WeaponGroup) -> void:
	weapon_group = group

func _ready() -> void:
	explosion_radius.shape.radius = weapon_group.get_explosion_radius()

	# I hate this
	await get_tree().create_timer(0.05).timeout
	_explode()
	
	var crater = CRATER.instantiate()
	GameManager.get_game_root().add_child(crater)
	crater.global_position = global_position
	crater.scale = Vector2.ONE * (weapon_group.get_explosion_radius()) / 75.0

func _explode() -> void:
	var nearby_enemies = get_overlapping_bodies()
	# Randomly pitch the sound effect up/down to add variety.
	explosion_sound_effect.pitch_scale = randf_range(0.8, 1.2)
	explosion_animation.play("explode")
	GameManager.explosion_occurred.emit()
	var knockback = damage_calculation.calculate_knockback()
	for enemy in nearby_enemies:
		if enemy is Enemy:
			enemy.take_damage(damage_calculation.calculate_damage(), knockback, global_position)
