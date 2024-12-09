class_name FragGrenadeExplosion extends Area2D

const FRAG_GRENADE_SHRAPNEL = preload("res://player/projectile/projectiles/frag_grenade_shrapnel/frag_grenade_shrapnel.tscn")
const CRATER = preload("res://player/projectile/crater.tscn")

var weapon_type: WeaponType = null
var player_stats: PlayerStats = null

@onready var explosion_animation: AnimationPlayer = $ExplosionAnimation
@onready var explosion_sound_effect: AudioStreamPlayer2D = $ExplosionSoundEffect
@onready var explosion_radius: CollisionShape2D = $ExplosionRadius
@onready var damage_calculation: ExplosionDamageCalculation = $DamageCalculation

func init(weapon: WeaponType, stats: PlayerStats, _damage: int) -> void:
	weapon_type = weapon
	player_stats = stats

func _ready() -> void:
	# I hate this
	explosion_radius.shape.radius = (weapon_type.explosion_radius + player_stats.added_explosive_radius) * player_stats.explosive_radius_mod
	await get_tree().create_timer(0.05).timeout
	_explode()

func _explode() -> void:
	var nearby_enemies = get_overlapping_bodies()
	# Randomly pitch the sound effect up/down to add variety.
	explosion_sound_effect.pitch_scale = randf_range(0.8, 1.2)
	explosion_animation.play("explode")
	GameManager.explosion_occurred.emit()
	var knockback = damage_calculation.calculate_knockback()
	for enemy in nearby_enemies:
		if enemy is Enemy:
			enemy.take_damage(damage_calculation.calculate_damage(), knockback)
	
	var crater = CRATER.instantiate()
	GameManager.get_game_root().add_child(crater)
	crater.global_position = global_position
	crater.scale = Vector2.ONE * (weapon_type.explosion_radius + player_stats.added_explosive_radius) / 75.0

func create_shrapnel() -> void:
	for i in range(weapon_type.projectile_count + player_stats.extra_projectiles):
		var shrapnel = FRAG_GRENADE_SHRAPNEL.instantiate()
		# Select a random angle between 0° and 360° (as radians) to launch the shrapnel projectile in.
		# NOTE: deg_to_rad assumes the value received is in radians, not degrees.
		var shrapnel_orientation = global_position.normalized().rotated(deg_to_rad(randi_range(0, 360)))
		shrapnel.init(weapon_type, player_stats, shrapnel_orientation)
		GameManager.get_game_root().add_child(shrapnel)
		shrapnel.position = global_position
