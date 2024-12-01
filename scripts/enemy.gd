class_name Enemy extends CharacterBody2D

var player: Player = null

@export var enemy_type: EnemyType = null
const EXPERIENCE_GEM = preload("res://scenes/experience_gem.tscn")

func initialize(start_position):
	self.position = start_position

func _ready() -> void:
	player = GameManager.get_player()

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
	# TODO: Make it actually take damage instead of dying instantly
	_on_death()

func _on_death() -> void:
	var gem = EXPERIENCE_GEM.instantiate()
	gem.experience_value = 1
	gem.global_transform = global_transform
	get_tree().root.add_child.call_deferred(gem)
	queue_free()
