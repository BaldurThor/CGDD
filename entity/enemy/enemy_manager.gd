class_name EnemyManager extends Node

var player: Player

@export var enemy_types: Array[EnemyType] = []
@export var spawn_radius: float = 300
@export var damage_numbers: Node

@onready var enemies: Node = $Enemies

func _init() -> void:
	GameManager.assign_enemy_manager(self)

func _on_enemy_timer_timeout() -> void:
	if player == null:
		player = GameManager.get_player()
	
	var enemy_type = enemy_types.pick_random()
	
	# Create a new instance of the Mob scene.
	var enemy = enemy_type.enemy_scene.instantiate()

	# Choose a random spawn location around the player in a circle
	var spawn_theta = randf_range(0, 2 * PI)
	var spawn_location = Vector2(cos(spawn_theta), sin(spawn_theta)) * spawn_radius + player.global_position
	
	enemy.initialize(spawn_location)
	
	#inject the damage numbers node into the enemy so it knows where to place the damage numbers!
	enemy.damage_label_parent = damage_numbers
	
	# Spawn the mob by adding it to the Main scene.
	enemies.add_child(enemy)
	
func find_target(target_prio : consts.TargetPriority) -> Node2D:
	if target_prio == consts.TargetPriority.CLOSEST:
		return get_closest_enemy_to_player()
	elif target_prio == consts.TargetPriority.FARTHEST:
		return get_farthest_enemy_to_player()
	elif target_prio == consts.TargetPriority.RANDOM:
		return get_random_enemy()
	elif target_prio == consts.TargetPriority.WEEKEST:
		return get_weekest_enemy()
		
	else:
		return get_closest_enemy_to_player()
		

func get_closest_enemy_to_player() -> Node2D:
	if player == null:
		player = GameManager.get_player()
	
	var all_enemies = enemies.get_children()
	var closest = null
	for enemy in all_enemies:
		if closest == null:
			closest = enemy
		elif player.position.distance_to(closest.position) > player.position.distance_to(enemy.position):
			closest = enemy
	return closest
	
	
func get_farthest_enemy_to_player() -> Node2D:
	if player == null:
		player = GameManager.get_player()
		
	var all_enemies = enemies.get_children()
	var farthest = null
	for enemy in all_enemies:
		if farthest == null:
			farthest = enemy
		elif player.position.distance_to(farthest.position) < player.position.distance_to(enemy.position):
			farthest = enemy
	return farthest

func get_random_enemy() -> Node2D:
	if player == null:
		player = GameManager.get_player()
		
	var all_enemies = enemies.get_children()
	var rand = randi_range(0,len(all_enemies))
	return all_enemies[rand]
	
func get_strongest_enemy():
	pass
	# not sure how we define the strongest
	
func get_weakest_enemy() -> Node2D:
	if player == null:
		player = GameManager.get_player()
		
	var all_enemies = enemies.get_children()
	var farthest = null
	for enemy in all_enemies:
		print(enemy)
		if farthest == null:
			farthest = enemy
		elif player.position.distance_to(farthest.position) < player.position.distance_to(enemy.position):
			farthest = enemy
	return farthest
	
