class_name Enemy extends RigidBody2D

var player: Player = null
var distance_to_player: float

const EXPERIENCE_GEM = preload("res://entity/experience/experience_gem.tscn")
const DAMAGE_LABEL = preload("res://entity/enemy/damage_label/damage_label.tscn")

@export var xp_drop_amount: int = 1

# Dependency injected from enemy manager
@export var damage_label_parent: Node

var damage_label: Node = null
var should_drop_xp: bool = true

@onready var entity_stats: EntityStats = %EntityStats
@onready var enemy_base: EnemyBase = $EnemyBase
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var target_velocity: Vector2
var current_velocity: Vector2

func _ready() -> void:
	player = GameManager.get_player()
	entity_stats.death.connect(_on_death)
	enemy_base.destroy_object.connect(queue_free)

func initialize(start_position: Vector2) -> void:
	position = start_position

func take_damage(damage: int, knockback_amount: int, damage_origin: Vector2, drop_xp: bool = true) -> void:
	should_drop_xp = drop_xp
	entity_stats.deal_damage(damage)
	_add_knockback(knockback_amount, damage_origin)
	GameManager.enemy_take_damage.emit(int(entity_stats.get_damage_applied(damage)))
	create_damage_label(damage)

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
		GameManager.get_game_root().add_child(self.damage_label)
	else:
		self.damage_label.update(self.position, damage)
