class_name WeaponGroup extends Node2D

@onready var manager: Node2D = $"../.."
@onready var weapons: Node2D = $Weapons
@onready var target_range: TargetRange = $TargetRange

## The identity of this weapon group (eg. "pistol", "shotgun"...)
var group_identity: String
var weapon_type: WeaponType = null
var player_stats: PlayerStats = null
var _scene_to_load: PackedScene = null
var weapon_archetype: WeaponGroupManager.WeaponArchetype

signal range_updated()

func init(
	identity: String,
	archetype: WeaponGroupManager.WeaponArchetype,
	weapon: WeaponType,
	stats: PlayerStats,
	scene: PackedScene
) -> void:
	group_identity = identity
	weapon_archetype = archetype
	weapon_type = weapon
	player_stats = stats
	_scene_to_load = scene

func _ready() -> void:
	var update_func: Callable = func(): return
	match weapon_archetype:
		WeaponGroupManager.WeaponArchetype.FIREARM:
			player_stats.player_ranged_range_changed.connect(_update_target_range_ranged)
			update_func = _update_target_range_ranged
		WeaponGroupManager.WeaponArchetype.MELEE, WeaponGroupManager.WeaponArchetype.ORBITAL_MELEE:
			player_stats.player_melee_range_changed.connect(_update_target_range_melee)
			update_func = _update_target_range_melee
	update_func.call()

func instantiate_weapon() -> void:
	var weapon = _scene_to_load.instantiate()
	weapon.init(weapon_type, player_stats, self, weapons.get_children().size())
	weapons.add_child.call_deferred(weapon)

func request_target(index: int) -> Enemy:
	var targets = target_range.get_targets()
	if targets.size() == 0:
		return null
	return targets[min(targets.size() - 1, index)]

func _update_target_range_ranged() -> void:
	var new_radius = weapon_type.attack_range * player_stats.ranged_range_mod
	target_range.target_range_shape.shape.radius = new_radius
	range_updated.emit()

func _update_target_range_melee() -> void:
	var new_radius = weapon_type.attack_range * player_stats.melee_range_mod
	target_range.target_range_shape.shape.radius = new_radius
	range_updated.emit()
