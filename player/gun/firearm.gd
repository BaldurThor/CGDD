class_name Firearm extends Node2D

@export var weapon_type: WeaponType
@export var bullet_type: PackedScene
@export var player_stats: PlayerStats

# Initializing this object via scene does not allow you to use _init.
# Call this method before adding this object to the scene tree!
func init(weapon: WeaponType, bullet: PackedScene, stats: PlayerStats) -> void:
	self.weapon_type = weapon
	self.bullet_type = bullet
	self.player_stats = stats
