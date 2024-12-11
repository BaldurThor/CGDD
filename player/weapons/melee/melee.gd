class_name Melee extends Node2D

@export var weapon_type: WeaponType
@export var player_stats: PlayerStats
@export var melee_weapon_scene: PackedScene

# Initializing this object via scene does not allow you to use _init.
# Call this method before adding this object to the scene tree!
func init(weapon: WeaponType, stats: PlayerStats) -> void:
	self.weapon_type = weapon
	self.player_stats = stats
	
