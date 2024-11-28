extends CharacterBody2D
class_name Enemy

var player: Player = null

var enemy_type: EnemyType = null

func initialize(start_position):
	self.position = start_position

func _ready() -> void:
	player = GameManager.get_player()

func _physics_process(_delta: float) -> void:
	# Make sure a player is present
	if !player:
		return
	
	# Move towards the player
	var dir = (player.global_position - global_position).normalized()
	move_and_collide(dir * 1.0) # TODO: add delta to the calculation!
