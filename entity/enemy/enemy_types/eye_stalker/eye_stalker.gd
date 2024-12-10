extends Enemy

var target_velocity: Vector2
var current_velocity: Vector2

func initialize(start_position: Vector2) -> void:
	position = start_position

func _physics_process(delta: float) -> void:
	pass

func _add_knockback(amount: int, damage_origin: Vector2) -> void:
	var knockback_amount = amount * entity_stats.self_knockback_mod
	if knockback_amount > 0.0:
		var knockback_direction = damage_origin.direction_to(global_position)
		current_velocity = knockback_direction * knockback_amount

func _on_death() -> void:
	if should_drop_xp:
		var gem = EXPERIENCE_GEM.instantiate()
		gem.experience_value = xp_drop_amount
		gem.global_transform = global_transform
		GameManager.get_game_root().add_child.call_deferred(gem)
	
	# Disable the rigidbody
	collision_mask = 0
	collision_layer = 0
	
	GameManager.enemy_died.emit()

func create_damage_label(damage: int) -> void:
	if self.damage_label == null:
		self.damage_label = DAMAGE_LABEL.instantiate()
		self.damage_label.initialize(self.position, damage, self.entity_stats.max_health)
		damage_label_parent.add_child(self.damage_label)
	else:
		self.damage_label.update(self.position, damage)
