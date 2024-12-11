extends LogicNode

@export var enemy: Enemy
@onready var logic_tree: LogicTree = $".."

@export var max_distance_to_player: float = 215.0
## If true, the max_distance_to_player variable is ignored.
@export var always_chase: bool = false
@export var collision_timout: float = 1.
@export var angle_range: float = 45.

var player: Player = null
var collide_counter: float = 0.
var stuck: float = 0.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = GameManager.get_player()
	var dir: Vector2 = player.global_position - enemy.global_position
	enemy.distance_to_player = dir.length()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# Make sure a player is present
	if !player:
		return
	var dir: Vector2 = player.global_position - enemy.global_position
	enemy.distance_to_player = dir.length()
	if always_chase or enemy.distance_to_player > max_distance_to_player:
		# Move towards the player
		var dir_norm: Vector2 = dir.normalized()
		if stuck != 0.:
			dir_norm = dir_norm.rotated(deg_to_rad(stuck))
		enemy.target_velocity = dir_norm * enemy.entity_stats.movement_speed
		enemy.current_velocity = enemy.current_velocity.move_toward(enemy.target_velocity, delta * 10.0)
		
		enemy.enemy_base.sprite_2d.flip_h = dir_norm.x < 0
		
		var coll: KinematicCollision2D = enemy.move_and_collide(enemy.current_velocity * delta * 100.0)

		if coll:
			if coll.get_collider_id() == player.get_instance_id():
				player.take_damage(enemy.entity_stats.contact_damage, enemy)
			else:
				collide_counter += delta
				if collide_counter > collision_timout:
					if stuck == 0.:
						stuck = randf_range(-angle_range, angle_range)
		elif collide_counter > 0.:
			collide_counter -= delta
		elif collide_counter < 0.:
			collide_counter = 0.
			stuck = 0.

func evaluate() -> bool:
	if always_chase:
		return false
	return enemy.distance_to_player < max_distance_to_player

func execute_logic() -> void:
	for child in get_children():
		if child.evaluate():
			child.execute_logic()
			break
