class_name Firearm extends Node2D

@export var weapon_type: WeaponType
@export var bullet_type: PackedScene
@export var player_stats: PlayerStats

func init(weapon: WeaponType, bullet: PackedScene, stats: PlayerStats) -> void:
	self.weapon_type = weapon
	self.bullet_type = bullet
	self.player_stats = stats

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
