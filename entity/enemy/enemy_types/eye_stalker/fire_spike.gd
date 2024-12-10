extends LogicNode

@onready var enemy: RigidBody2D = $"../../.."
@onready var parent_node: Node = $".."
@onready var cooldown_timer: Timer = $CooldownTimer

@export var cooldown: float = 2.5

var can_fire: bool = true
const SPIKE = preload("res://entity/enemy/enemy_types/eye_stalker/spike.tscn")

func _ready() -> void:
	cooldown_timer.wait_time = cooldown
	cooldown_timer.timeout.connect(func(): can_fire = true)

func _start_cooldown() -> void:
	cooldown_timer.start()

func evaluate() -> bool:
	return can_fire

func execute_logic() -> void:
	var player_position = parent_node.player.global_position
	var spike = SPIKE.instantiate()
	
	spike.init(enemy.entity_stats, enemy.global_position.direction_to(player_position))
	get_tree().root.add_child(spike)
	spike.position = enemy.global_position
	can_fire = false
	cooldown_timer.start()
