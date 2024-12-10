extends Area2D

@onready var enemy: Enemy = $".."
var player: Player = null

func _ready() -> void:
	player = GameManager.get_player()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var colliders = get_overlapping_bodies()
	for collider in colliders:
		if collider is Player:
			player.take_damage(enemy.entity_stats.contact_damage, enemy)
