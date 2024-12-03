class_name Enemy extends CharacterBody2D

var player: Player = null
var type: EnemyType = null

const EXPERIENCE_GEM = preload("res://entity/experience/experience_gem.tscn")
@onready var stat_manager: StatManager = $StatManager

func initialize(start_position: Vector2, enemy_type: EnemyType):
	position = start_position
	type = enemy_type

func _ready() -> void:
	player = GameManager.get_player()
	stat_manager.stats = type.stats.duplicate()
	stat_manager.stats.death.connect(_on_death)

func _physics_process(_delta: float) -> void:
	# Make sure a player is present
	if !player:
		return
	
	# Move towards the player
	var dir: Vector2 = (player.global_position - global_position).normalized()
	var coll: KinematicCollision2D = move_and_collide(dir * type.stats.movement_speed)

	if coll:
		if coll.get_collider_id() == player.get_instance_id():
			player.take_damage(type.stats.contact_damage)
			
func take_damage(raw_amount: int) -> void:
	stat_manager.take_damage.emit(raw_amount)

func _on_death() -> void:
	var gem = EXPERIENCE_GEM.instantiate()
	gem.experience_value = 1
	gem.global_transform = global_transform
	get_tree().root.add_child.call_deferred(gem)
	queue_free()
