@tool
@icon("res://entity/enemy/enemy_base_icon.svg")
class_name EnemyBase extends Node2D

signal destroy_object

@onready var sprite_2d: EntitySprite = $Sprite2D
@onready var health_bar: HealthBar = $HealthBar
@onready var hit_sfx: AudioStreamPlayer2D = $HitSFX
@onready var death_sfx: AudioStreamPlayer2D = $DeathSFX
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var sprite: Texture2D:
	set(value):
		sprite = value
		if Engine.is_editor_hint():
			$Sprite2D.texture = value

@export var entity_stats: EntityStats:
	set(value):
		entity_stats = value
		if Engine.is_editor_hint():
			$HealthBar.stats_node = value
			update_configuration_warnings()

@export var sprite_scale: float = 1.0:
	set(value):
		sprite_scale = value
		if Engine.is_editor_hint():
			$Sprite2D.scale = Vector2.ONE * value

@export var sprite_offset: Vector2 = Vector2.ZERO:
	set(value):
		sprite_offset = value
		if Engine.is_editor_hint():
			$Sprite2D.position = sprite_offset

@export var sprite_modulate: Color = Color.WHITE:
	set(value):
		sprite_modulate = value
		if Engine.is_editor_hint() and sprite_2d != null:
			sprite_2d.material.set_shader_parameter("modulate", value)

@export var show_health_bar: bool = true:
	set(value):
		show_health_bar = value
		if Engine.is_editor_hint() and health_bar != null:
			health_bar.visible = value

func _ready():
	sprite_2d.texture = sprite
	health_bar.stats_node = entity_stats
	entity_stats.death.connect(_on_death)
	entity_stats.take_damage.connect(_on_take_damage)
	sprite_2d.scale = Vector2.ONE * sprite_scale
	sprite_2d.position = sprite_offset
	sprite_2d.material.set_shader_parameter("modulate", sprite_modulate)
	health_bar.visible = show_health_bar

func _on_death():
	animation_player.play("death")
	sprite_2d.visible = false
	health_bar.visible = false
	await animation_player.animation_finished
	destroy_object.emit()

func _on_take_damage(_amt: int):
	sprite_2d.flash()
	hit_sfx.pitch_scale = randf_range(0.8, 1.2)
	hit_sfx.play()

func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	
	if entity_stats == null:
		warnings.push_back("Missing Entity Stats")
	
	return warnings
