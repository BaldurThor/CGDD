class_name Enemy extends RigidBody2D

var player: Player = null
var distance_to_player: float


## The items that the entity can drop. Modify the drop rate in item_drop_chances.
## These scene roots must inherit from PickupBase.
@export var item_drops: Array[PackedScene] = []

## The chance of an item in item_drops with the same index as
## an entry in this array dropping when the entity dies.
@export var item_drop_chances: Array[float] = []

## If an item drops from this entity on death, this is the value passed to it.
@export var item_drop_values: Array[int] = []

const DAMAGE_LABEL = preload("res://entity/enemy/damage_label/damage_label.tscn")
# Dependency injected from enemy manager
@export var damage_label_parent: Node

var damage_label: Node = null
var should_drop_items: bool = true

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

func take_damage(damage: int, knockback_amount: int, damage_origin: Vector2, drop_items: bool = true) -> void:
	should_drop_items = drop_items
	entity_stats.deal_damage(damage)
	_add_knockback(knockback_amount, damage_origin)
	GameManager.enemy_take_damage.emit(int(entity_stats.get_damage_applied(damage)))
	create_damage_label(damage)

func _add_knockback(amount: int, damage_origin: Vector2) -> void:
	var knockback_amount = amount * entity_stats.self_knockback_mod
	if knockback_amount > 0.0:
		var knockback_direction = damage_origin.direction_to(global_position)
		current_velocity = knockback_direction * knockback_amount

func _spawn_drops() -> void:
	for i in item_drops.size():
		var item = item_drops[i]
		var drop_chance = item_drop_chances[i]
		var should_drop: bool = drop_chance == 1.0 or drop_chance >= randf()
		if should_drop:
			var instance = item.instantiate()
			instance.assign_value(item_drop_values[i])
			instance.global_transform = global_transform
			GameManager.get_game_root().add_child.call_deferred(instance)

func _on_death() -> void:
	if should_drop_items:
		_spawn_drops()
	
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
