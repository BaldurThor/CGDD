class_name Player extends CharacterBody2D

@onready var player_stats: PlayerStats = %PlayerStats
@onready var pick_up_sound_effect: AudioStreamPlayer2D = $PickUpSoundEffect
@onready var sprite: EntitySprite = $PlayerSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var experience: Experience = %Experience
@onready var hud_modulate: CanvasModulate = %HUDModulate
@onready var level_switcher: Node2D = %LevelSwitcher
@onready var camera: PlayerCamera = $Camera2D
@onready var weapon_group_manager: WeaponGroupManager = $WeaponGroupManager
@onready var ability_system: AbilitySystem = %AbilitySystem
@onready var ability_selector: AbilitySelector = %AbilitySelector
@onready var medkit_pickup_sfx: AudioStreamPlayer2D = $MedkitPickupSFX
@onready var heart_pickup_sfx: AudioStreamPlayer2D = $HeartPickupSFX
@onready var enemy_borders: Node2D = $EnemyBorders

@export var freeze_player: bool = false
@export var death_screen: PackedScene

var last_damage_from: Enemy

signal healed_amount(amount : int, regen : bool)

func _init() -> void:
	# Make sure GameManager knows about this player instance.
	# Called in _init() instead of _ready() to make sure it's
	# properly assigned for other scripts to access.
	GameManager.assign_player(self)
	GameManager.death = false
	
func _ready() -> void:
	ability_selector.request_weapon()

func _process(_delta: float) -> void:
	if Input.is_action_pressed("level_up"):
		ability_selector.request_menu()

func _physics_process(_delta: float) -> void:
	if freeze_player:
		return
	
	var x_direction := Input.get_axis("move_left", "move_right")
	var y_direction := Input.get_axis("move_up", "move_down")
	var direction := Vector2(x_direction, y_direction).normalized()
	
	if direction != Vector2.ZERO:
		animation_player.move_anim(player_stats.movement_speed)
	
	if x_direction != 0:
		sprite.flip_h = x_direction < 0
	
	velocity = (direction * player_stats.movement_speed) * player_stats.movement_speed_mod
	
	move_and_slide()
	
	for i in get_slide_collision_count():
		var col = get_slide_collision(i)
		if col.get_collider() is Enemy:
			col.get_collider().apply_force(col.get_normal() * -2000.0)

func take_damage(amount: int, enemy: Enemy) -> void:
	self.last_damage_from = enemy
	if freeze_player:
		return
	
	if player_stats.is_invincible:
		return

	if randf() < min(player_stats.absolute_max_dodge, player_stats.dodge_chance):
		amount = 0
	
	animation_player.play("take_damage")
	GameManager.player_take_damage.emit(int(player_stats.get_damage_applied(amount)))
	player_stats.deal_damage(amount)
	
func heal(value : int, regen : bool) -> void:
	var pref_health := player_stats.health
	player_stats.health += value
	var delta : int = player_stats.health - pref_health
	if delta > 0:
		healed_amount.emit(delta, regen)

func _on_player_stats_death() -> void:
	GameManager.death = true
	var death_node = death_screen.instantiate()
	death_node.initialize(last_damage_from)
	self.add_child(death_node)
	death_node.highlight_screen.position.x = self.position.x - death_node.highlight_screen.size.x / 2
	death_node.highlight_screen.position.y = self.position.y - death_node.highlight_screen.size.y / 2
