extends Enemy

@onready var sprite_2d: Sprite2D = $TentacleSlam/Sprite2D
@onready var attack_timer: Timer = $AttackTimer
@onready var cooldown_timer: Timer = $CooldownTimer
@onready var tentacle_slam: Area2D = $TentacleSlam

@export var rotation_speed: float = 1.5

func _process(delta: float) -> void:
	var dir: Vector2 = (player.global_position - global_position).normalized()
	var new_target_rotation: float = atan2(dir.y, dir.x)
	
	tentacle_slam.rotation = lerp_angle(tentacle_slam.rotation, atan2(dir.y, dir.x), delta * rotation_speed)
	
	var mat: ShaderMaterial = sprite_2d.material
	
	if not attack_timer.is_stopped():
		var attack_percentage = 1 - attack_timer.time_left / attack_timer.wait_time
		mat.set_shader_parameter("transparency", attack_percentage)
	else:
		mat.set_shader_parameter("transparency", 0)

func attack():
	for entity in tentacle_slam.get_overlapping_bodies():
		if entity.get_instance_id() == player.get_instance_id():
			player.take_damage(entity_stats.contact_damage)

func _on_cooldown_timer_timeout() -> void:
	attack_timer.start()
	await attack_timer.timeout
	attack()
	var mat: ShaderMaterial = sprite_2d.material
	mat.set_shader_parameter("flash", true)
	await get_tree().create_timer(0.1).timeout
	mat.set_shader_parameter("flash", false)
	cooldown_timer.start()

func _on_entity_stats_death() -> void:
	tentacle_slam.visible = false
	attack_timer.stop()
	cooldown_timer.stop()
