class_name Player extends CharacterBody2D

@onready var player_stats: PlayerStats = %PlayerStats
@onready var pick_up_sound_effect: AudioStreamPlayer2D = $PickUpSoundEffect
@onready var sprite: EntitySprite = $PlayerSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var experience: Experience = %Experience
@onready var hud_modulate: CanvasModulate = %HUDModulate
@onready var level_switcher: Node2D = %LevelSwitcher
@onready var ability_picker: AbilityPicker = %AbilityPicker
@onready var weapon_group_manager: WeaponGroupManager = $WeaponGroupManager

@export var freeze_player: bool = false
@export var death_screen: PackedScene

var last_damage_from: Enemy

func _init() -> void:
	# Make sure GameManager knows about this player instance.
	# Called in _init() instead of _ready() to make sure it's
	# properly assigned for other scripts to access.
	GameManager.assign_player(self)
	GameManager.death = false
	
func _ready() -> void:
	ability_picker.add_to_backlog(AbilityPicker.ChoiceType.WEAPONS)

func _physics_process(_delta: float) -> void:
	if freeze_player:
		return
	
	var x_direction := Input.get_axis("move_left", "move_right")
	var y_direction := Input.get_axis("move_up", "move_down")
	var direction := Vector2(x_direction, y_direction).normalized()
	
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
	
	if randf() < min(player_stats.absolute_max_dodge, player_stats.dodge_chance):
		amount = 0
	
	GameManager.player_take_damage.emit(int(player_stats.get_damage_applied(amount)))
	animation_player.play("take_damage")
	if player_stats.is_invincible:
		return
	player_stats.deal_damage(amount)
	
func heal(value) -> void:
	player_stats.health += value

func _on_player_stats_death() -> void:
	GameManager.death = true
	var death_node = death_screen.instantiate()
	death_node.initialize(last_damage_from)
	self.add_child(death_node)
	death_node.fade_to_black.position.x = self.position.x - death_node.fade_to_black.size.x / 2
	death_node.fade_to_black.position.y = self.position.y - death_node.fade_to_black.size.y / 2
