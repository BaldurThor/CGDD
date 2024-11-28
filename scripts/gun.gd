extends Node2D
class_name Gun
const BULLET = preload("res://scenes/bullet.tscn")

@onready var player: Player = $"../.."
@onready var attack_timer: Timer = $AttackTimer
@onready var gun_swivel: GunSwivel = $".."
var fire_rate: float = 0.05
var damage: int = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attack_timer.timeout.connect(_attack)
	attack_timer.wait_time = fire_rate
	attack_timer.start()

func _attack() -> void:
	var bullet = BULLET.instantiate()
	bullet.init(damage, 500, gun_swivel.global_transform.x)
	get_tree().root.add_child(bullet)
	bullet.position = global_position
