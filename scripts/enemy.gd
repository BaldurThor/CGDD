@tool
extends RigidBody2D

var player: Player = null

@export var enemy_type: EnemyType:
	set(value):
		enemy_type = value
		update_configuration_warnings()

func _ready() -> void:
	player = GameManager.get_player()

func _physics_process(delta: float) -> void:
	# Don't update if the script is running in the editor (required since
	# this is marked as a tool script, meaning it runs in the editor)
	if Engine.is_editor_hint():
		return
	
	# Make sure a player is present
	if !player:
		return
	
	# Move towards the player
	var dir : Vector2 = (player.global_position - global_position).normalized()
	var coll : KinematicCollision2D = move_and_collide(dir * enemy_type.speed)

	if coll:
		if coll.get_collider_id() == player.get_instance_id():
			player.take_damage(enemy_type.dagame)
			

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	
	# Show a warning if this enemy is not given a time
	if enemy_type == null:
		warnings.append("Missing enemy type")
	
	return warnings
	

	print("Collison")
