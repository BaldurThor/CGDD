class_name Gun extends Node2D

@onready var attack_timer: Timer = $AttackTimer
@onready var burst_timer: Timer = $BurstTimer
@onready var gun_sprite: Sprite2D = $GunSprite
@onready var attack_sound_effect: AudioStreamPlayer2D = $AttackSoundEffect
@onready var swivel: GunSwivel = $"../"

@onready var gun_swivel: GunSwivel = $".."
@onready var firearm: Firearm = $"../.."

var can_attack: bool = true
var weapon_type: WeaponType = null
var projectile_type: PackedScene
var player_stats: PlayerStats


signal _burst_attack_signal()
signal _normal_attack_signal()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	weapon_type = firearm.weapon_type
	projectile_type = firearm.weapon_type.projectile
	player_stats = firearm.player_stats
	attack_timer.timeout.connect(_permit_attacking)
	attack_timer.wait_time = firearm.weapon_group.calculate_total_attack_speed()
	attack_timer.start()
	firearm.weapon_group.attack_speed_updated.connect(_update_attack_speed)
	gun_sprite.texture = weapon_type.sprite
	gun_sprite.scale = weapon_type.sprite_scale
	_burst_attack_signal.connect(_burst_attack)
	_normal_attack_signal.connect(_normal_attack)
	attack_sound_effect.stream = weapon_type.attack_sfx
	
func _permit_attacking() -> void:
	can_attack = true

func _process(_delta: float) -> void:
	if can_attack and swivel.enemy != null:
		can_attack = false
		if weapon_type.burst == true:
			_burst_attack_signal.emit()
		else:
			_normal_attack_signal.emit()
		attack_timer.start()

func _calculate_spread_vector() -> Vector2:
	var degrees = weapon_type.projectile_spread.sample(randf()) / 2
	# Give the projectile a 50% chance of having the angle inverted
	var sign_multiplier = [-1, 1].pick_random()
	var rad = deg_to_rad(degrees)
	# Rotate the angle by rad or -rad
	var angle = global_transform.x.rotated(rad * sign_multiplier)
	return angle


func _normal_attack() -> void:
	# Create a bullet and face it in the same direction of the gun swivel
	var angle = _calculate_spread_vector()
	var bullet = projectile_type.instantiate()
	_play_attack_sfx()
	bullet.init(firearm.weapon_group, angle)
	GameManager.get_game_root().add_child(bullet)
	bullet.position = global_position

func _burst_attack() -> void:
	if weapon_type.delay_between_burst_projectiles > 0:
		burst_timer.wait_time = weapon_type.delay_between_burst_projectiles
	for i in range(firearm.weapon_group.get_total_projectiles()):
		_normal_attack()
		if weapon_type.delay_between_burst_projectiles > 0:
			burst_timer.start()
			await burst_timer.timeout

func _play_attack_sfx() -> void:
	# Randomly pitch the sound effect up/down to add variety.
	var pitch_modification = randf_range(0.5, 2)
	attack_sound_effect.pitch_scale = pitch_modification
	attack_sound_effect.play()

## Requests the newly updated attack speed from the weapon group.
func _update_attack_speed() -> void:
	var attack_speed = firearm.weapon_group.calculate_total_attack_speed()
	attack_timer.wait_time = attack_speed
