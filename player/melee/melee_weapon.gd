class_name MeleeWeapon extends Node2D

var _can_attack: bool = true

@onready var attack_timer: Timer = $AttackTimer
@onready var melee: Melee = $"../.."
@onready var melee_target_range: MeleeTargetRange = $MeleeTargetRange
@onready var melee_swivel: MeleeSwivel = $".."
@onready var melee_damage_calculation: MeleeDamageCalculation = $"../../MeleeDamageCalculation"
@onready var melee_sprite: Sprite2D = $MeleeSprite
@onready var melee_strike_range: Area2D = $MeleeTargetRange/MeleeStrikeRange

signal _attack_signal(enemy: Enemy)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_attack_signal.connect(_attack)
	melee_sprite.texture = melee.weapon_type.sprite
	attack_timer.wait_time = melee.weapon_type.attack_speed / (melee.player_stats.attack_speed_mod * melee.player_stats.melee_attack_speed_mod)
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	attack_timer.start()

func _on_attack_timer_timeout() -> void:
	_can_attack = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _can_attack:
		if melee_swivel.enemy != null:
			_can_attack = false
			_attack_signal.emit(melee_swivel.enemy)
			
func _attack(enemy: Enemy) -> void:
	melee_strike_range.look_at(enemy.global_position)
	var strikes = melee.weapon_type.melee_strike_count + melee.player_stats.added_melee_strikes
	for i in range(strikes):
		var has_enemies = _strike()
		if has_enemies:
			await get_tree().create_timer(melee.weapon_type.melee_strike_delay).timeout
		else:
			# No enemies in range. Restart the cooldown instantly instead of attacking the air.
			break
	attack_timer.start()

## Attacks all enemies in the area. Returns a boolean indicating whether enemies were found or not.
func _strike() -> bool:
	var targets = melee_strike_range.get_overlapping_bodies()
	if targets.size() == 0:
		return false
	# Swing like a madman!
	var tween = get_tree().create_tween()
	melee_sprite.rotation = 24.0
	tween.tween_property(melee_sprite, "rotation", -24.0, 0.2).set_trans(Tween.TRANS_LINEAR)
	var knockback = melee_damage_calculation.calculate_knockback()
	for target in targets:
		if target is Enemy:
			target.take_damage(melee_damage_calculation.calculate(), knockback)
	return true
