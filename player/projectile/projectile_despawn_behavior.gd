class_name ProjectileDespawnBehavior extends Node

@onready var projectile: Projectile = $".."
@export var scene_to_spawn_on_despawn: PackedScene = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	projectile.despawn.connect(_handle_despawn)

func _handle_despawn() -> void:
	if scene_to_spawn_on_despawn != null:
		var obj: Node2D = scene_to_spawn_on_despawn.instantiate()
		if obj.has_method("init"):
			obj.init(projectile.weapon_type, projectile.player_stats, projectile.calculate_damage())
		obj.global_position = projectile.global_position
		GameManager.get_game_root().add_child(obj)
	projectile.queue_free.call_deferred()
