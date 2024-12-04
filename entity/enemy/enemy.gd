class_name Enemy extends CharacterBody2D

var player: Player = null

const EXPERIENCE_GEM = preload("res://entity/experience/experience_gem.tscn")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var xp_drop_amount: int = 1

@onready var entity_stats: EntityStats = %EntityStats
@onready var hit_sfx: AudioStreamPlayer2D = $HitSFX

func initialize(start_position: Vector2):
	position = start_position

func _ready() -> void:
	player = GameManager.get_player()
	entity_stats.death.connect(_on_death)

func _physics_process(_delta: float) -> void:
	# Make sure a player is present
	if !player:
		return
	
	# Move towards the player
	var dir: Vector2 = (player.global_position - global_position).normalized()
	var coll: KinematicCollision2D = move_and_collide(dir * entity_stats.movement_speed)

	if coll:
		if coll.get_collider_id() == player.get_instance_id():
			player.take_damage(entity_stats.contact_damage)
			
func take_damage(damage: int) -> void:
	animation_player.play("take_damage")
	hit_sfx.pitch_scale = randf_range(0.8, 1.2)
	entity_stats.deal_damage(damage)
	GameManager.enemy_take_damage.emit(int(entity_stats.get_damage_applied(damage)))

func _on_death() -> void:
	var gem = EXPERIENCE_GEM.instantiate()
	gem.experience_value = xp_drop_amount
	gem.global_transform = global_transform
	var run = get_node("/root/Main/Run")
	run.add_child.call_deferred(gem)
	queue_free()
	animation_player.play("death")
