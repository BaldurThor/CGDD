extends CharacterBody2D
class_name Enemy

var player: Player = null

@export var enemy_type: EnemyType = null

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
