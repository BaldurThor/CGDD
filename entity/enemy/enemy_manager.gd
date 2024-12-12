class_name EnemyManager extends Node

var player: Player
var timers: Dictionary = {}
var enemy_count: int = 0

const MAX_ENEMIES: int = 500

@export var level_spawn_settings: Array[LevelSpawnSettings] = []
@export var spawn_radius: float = 300
@export var damage_numbers: Node
@export var bosses: Array[PackedScene] = []

@onready var enemies: Node = $Enemies

func _init() -> void:
	GameManager.assign_enemy_manager(self)

func _ready():
	_init_level()
	GameManager.new_world_level.connect(_init_level)
	GameManager.new_world_level_active.connect(_spawn_boss)
	GameManager.enemy_died.connect(func(): enemy_count -= 1)
	GameManager.game_timer_over.connect(_spawn_cthulhu)

func _process(_delta: float):
	if GameManager.freeze_enemies:
		return
	
	var level_spawn: LevelSpawnSettings = level_spawn_settings[GameManager.world_level - 1]
	var level_progress = GameManager.get_world_level_progress()
	for enemy: EnemySpawnSettings in level_spawn.enemies:
		var timer: Timer = timers[enemy]
		var adjusted = enemy.spawn_rate_curve.sample(level_progress)
		timer.wait_time = lerpf(enemy.starting_spawn_rate, enemy.ending_spawn_rate, adjusted)

func _spawn_cthulhu() -> void:
	var cthulhu_scene = bosses[-1]
	var cthulhu: Boss = cthulhu_scene.instantiate()
	add_child(cthulhu)
	cthulhu.global_position = GameManager.get_player().global_position + cthulhu.spawn_offset


func _spawn_boss() -> void:
	if GameManager.world_level > 1:
		var boss_scene = bosses[GameManager.world_level - 2]
		var boss: Boss = boss_scene.instantiate()
		add_child(boss)
		boss.global_position = GameManager.get_player().global_position + boss.spawn_offset

func _init_level() -> void:
	enemy_count = 0
	var level_spawn = level_spawn_settings[GameManager.world_level - 1]

	for elem in timers.values():
		elem.queue_free()
	
	timers.clear()
	
	for enemy: EnemySpawnSettings in level_spawn.enemies:
		var timer = Timer.new()
		add_child(timer)
		timer.wait_time = enemy.starting_spawn_rate
		timer.timeout.connect(func(): _on_enemy_timer_timeout(enemy))
		timers[enemy] = timer
		timer.start()

func _on_enemy_timer_timeout(enemy_spawn: EnemySpawnSettings) -> void:
	if player == null:
		player = GameManager.get_player()
	
	if GameManager.freeze_enemies:
		return
	
	if enemy_count >= MAX_ENEMIES:
		return
	
	# Create a new instance of the Mob scene.
	var enemy = enemy_spawn.enemy_type.enemy_scene.instantiate()
	enemy_count += 1

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
	elif target_prio == consts.TargetPriority.WEAKEST:
		return get_closest_enemy_to_player()
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
	
func get_weakest_enemy():
	pass
	
	
