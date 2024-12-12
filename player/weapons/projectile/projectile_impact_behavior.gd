class_name ProjectileImpactBehavior extends Node

@onready var projectile: Projectile = $".."
@export var deal_damage: bool = true
@export var disable_collision_on_impact: bool = false
@export var knockback_on_hit: bool = true
@export var despawn_on_hit: bool = true
## If despawn_on_hit is false, this timer will determine the projectile's lifetime.
@export var time_before_despawn: float = 0.0
@export var can_pierce: bool = true

var collision_count: int = 0
var max_pierce_count: int = 0
var timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_pierce_count = projectile.weapon_type.pierce_count + projectile.player_stats.extra_projectile_pierce
	projectile.body_entered.connect(_handle_impact)
	if !despawn_on_hit and time_before_despawn > 0.0:
		timer = Timer.new()
		timer.wait_time = time_before_despawn
		timer.process_mode = PROCESS_MODE_PAUSABLE
		add_child(timer)
		timer.start()
		timer.timeout.connect(_on_timeout)

func _handle_impact(collided_with: Node2D) -> void:
	if collided_with is Enemy:
		if collided_with.entity_stats.get_health_percentage() <= 0.0:
			return
		if deal_damage:
			collided_with.take_damage(projectile.calculate_damage(), projectile.calculate_knockback(), projectile.global_position)
		if disable_collision_on_impact:
			projectile.collision_layer = 0
			projectile.collision_mask = 0
		collision_count += 1
		if despawn_on_hit or (can_pierce and max_pierce_count == collision_count - 1):
			projectile.despawn.emit()

func _on_timeout() -> void:
	projectile.despawn.emit()
