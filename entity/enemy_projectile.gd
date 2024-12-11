class_name EnemyProjectile extends Area2D

@export var damage_on_hit: int = 0
@export var projectile_speed: float = 70.0
@export var final_projectile_speed: float = 70.0
@export var homing_strength: float = 0.0
@export var look_at_player: bool = false
@export var look_in_travel_direction: bool = false
@export var despawn_timer: float = 5.0

var direction: Vector2
var entity_stats: EntityStats
var enemy: Enemy
var timer: Timer

signal despawn

func init(
	bullet_direction: Vector2,
	owning_enemy: Enemy,
	despawn_time: float,
	starting_speed: float,
	final_speed: float,
) -> void:
	enemy = owning_enemy
	entity_stats = enemy.entity_stats
	direction = bullet_direction.normalized()
	despawn_timer = despawn_time
	projectile_speed = starting_speed
	final_projectile_speed = final_speed

func _ready() -> void:
	body_entered.connect(_handle_impact)
	despawn.connect(queue_free)
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = despawn_timer
	timer.timeout.connect(_on_timeout)
	timer.start()
	enemy.entity_stats.death.connect(queue_free)


func _handle_impact(collided_with: Node2D) -> void:
	if collided_with is Player:
		if collided_with.player_stats.get_health_percentage() <= 0.0:
			return
		collided_with.take_damage(damage_on_hit, enemy)
		despawn.emit()

func _physics_process(delta: float) -> void:
	if look_in_travel_direction:
		look_at(position + direction)
	elif look_at_player:
		look_at(GameManager.get_player().global_position)
	
	var dir_to_player = GameManager.get_player().global_position - global_position
	var angle_to_player = atan2(dir_to_player.y, dir_to_player.x)
	var new_angle = lerp_angle(rotation, angle_to_player, homing_strength * delta)
	direction = Vector2(cos(new_angle), sin(new_angle))
	
	var progress = 1 - timer.time_left / timer.wait_time
	var speed = lerpf(projectile_speed, final_projectile_speed, progress)
	
	position += direction * speed * delta

func _on_timeout() -> void:
	despawn.emit()
