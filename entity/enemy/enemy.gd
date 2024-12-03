class_name Enemy extends CharacterBody2D

var player: Player = null
var type: EnemyType = null

@export var enemy_type: EnemyType = null
const EXPERIENCE_GEM = preload("res://entity/experience/experience_gem.tscn")

@onready var entity_health: EntityHealth = $EntityHealth

func initialize(start_position: Vector2, enemy_type: EnemyType):
	position = start_position
	type = enemy_type

func _ready() -> void:
	player = GameManager.get_player()
	entity_health.death.connect(_on_death)

func _physics_process(_delta: float) -> void:
	# Make sure a player is present
	if !player:
		return
	
	# Move towards the player
	var dir: Vector2 = (player.global_position - global_position).normalized()
	var coll: KinematicCollision2D = move_and_collide(dir * enemy_type.speed)

	if coll:
		if coll.get_collider_id() == player.get_instance_id():
			player.take_damage(enemy_type.damage)
			
func take_damage(damage: int) -> void:
	entity_health.deal_damage(damage)

func _on_death() -> void:
	var gem = EXPERIENCE_GEM.instantiate()
	gem.experience_value = enemy_type.xp_drop_amount
	gem.global_transform = global_transform
	get_tree().root.add_child.call_deferred(gem)
	queue_free()
