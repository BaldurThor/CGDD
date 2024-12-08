class_name Enemy extends CharacterBody2D

var player: Player = null
var distance_to_player: float

const EXPERIENCE_GEM = preload("res://entity/experience/experience_gem.tscn")
const DAMAGE_LABEL = preload("res://entity/enemy/damage_label/damage_label.tscn")

@export var xp_drop_amount: int = 1

# Dependency injected from enemy manager
@export var damage_label_parent: Node
@export var contact_damage_override: Area2D

@onready var entity_stats: EntityStats = %EntityStats
@onready var enemy_base: EnemyBase = $EnemyBase
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func initialize(start_position: Vector2) -> void:
	position = start_position

func _ready() -> void:
	player = GameManager.get_player()
	entity_stats.death.connect(_on_death)
	enemy_base.destroy_object.connect(queue_free)

func _physics_process(_delta: float) -> void:
	# Make sure a player is present
	if !player:
		return
	
	# Move towards the player
	var dir: Vector2 = player.global_position - global_position
	distance_to_player = dir.length()
	var dir_norm: Vector2 = dir.normalized()
	var coll: KinematicCollision2D = move_and_collide(dir_norm * entity_stats.movement_speed)
	
	if contact_damage_override != null and contact_damage_override.has_overlapping_bodies():
		for body in contact_damage_override.get_overlapping_bodies():
			if body.get_instance_id() == player.get_instance_id():
				body.take_damage(entity_stats.contact_damage)
				return
	
	if coll:
		if coll.get_collider_id() == player.get_instance_id():
			player.take_damage(entity_stats.contact_damage)
	
func take_damage(damage: int) -> void:
	entity_stats.deal_damage(damage)
	GameManager.enemy_take_damage.emit(int(entity_stats.get_damage_applied(damage)))
	create_damage_label(damage)

func _on_death() -> void:
	var gem = EXPERIENCE_GEM.instantiate()
	gem.experience_value = xp_drop_amount
	gem.global_transform = global_transform
	var run = get_node("/root/Main/Run")
	run.add_child.call_deferred(gem)
	
	# Disable the rigidbody
	collision_mask = 0
	collision_layer = 0
	
	if contact_damage_override != null:
		contact_damage_override.collision_mask = 0
		contact_damage_override.collision_layer = 0

func create_damage_label(damage: int) -> void:
	var label = DAMAGE_LABEL.instantiate()
	label.initialize(self.position, damage)
	damage_label_parent.add_child(label)
