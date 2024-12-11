class_name Melee extends Node2D

@export var weapon_type: WeaponType
@export var player_stats: PlayerStats
@export var melee_weapon_scene: PackedScene
var weapon_group: WeaponGroup
var index_in_group: int

# Initializing this object via scene does not allow you to use _init.
# Call this method before adding this object to the scene tree!
func init(weapon: WeaponType, stats: PlayerStats, group: WeaponGroup, index: int) -> void:
	self.weapon_type = weapon
	self.player_stats = stats
	self.weapon_group = group
	self.index_in_group = index
