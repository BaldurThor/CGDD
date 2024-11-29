class_name Gun extends Node2D

@onready var player: Player = $"../.."
@onready var attack_timer: Timer = $AttackTimer
@onready var burst_timer: Timer = $BurstTimer
@onready var sprite_2d: Sprite2D = $Sprite2D

@export var fire_rate: float = 1.0
@export var damage: int = 3
@export var weapon_type: WeaponType

signal _burst_attack_signal

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attack_timer.timeout.connect(_attack)
	attack_timer.wait_time = fire_rate
	attack_timer.start()
	sprite_2d.texture = weapon_type.sprite
	_burst_attack_signal.connect(_burst_attack)

func _attack() -> void:
	if weapon_type.burst == true:
		_burst_attack_signal.emit()
		return
	return _normal_attack()
	
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
	var bullet = weapon_type.bullet_type.instantiate()
	var angle = _calculate_spread_vector()
	bullet.init(damage, weapon_type.projectile_speed, angle)
	get_tree().root.add_child(bullet)
	bullet.position = global_position

func _burst_attack() -> void:
	if weapon_type.delay_between_burst_projectiles > 0:
		burst_timer.wait_time = weapon_type.delay_between_burst_projectiles
	for i in range(weapon_type.projectile_count):
		_normal_attack()
		if weapon_type.delay_between_burst_projectiles > 0:
			burst_timer.start()
			await burst_timer.timeout
