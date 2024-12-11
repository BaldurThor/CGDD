class_name WeaponGroupManager extends Node2D

enum WeaponArchetype {
	FIREARM,
	MELEE,
	ORBITAL_MELEE,
}

@onready var groups: Node2D = $Groups
@onready var player_stats: PlayerStats = %PlayerStats

const FIREARM = preload("res://player/weapons/gun/firearm.tscn")
const MELEE_WEAPON = preload("res://player/weapons/melee/melee_weapon.tscn")
const ORBITAL_MELEE_WEAPON = preload("res://player/weapons/orbital_melee/orbital_melee_weapon.tscn")

## group_identity is a unique string name describing what weapon this belongs to
## weapon_archetype 
## scene is the weapon type, eg. Firearm or Melee.
func add_weapon(group_identity: String, weapon_archetype: WeaponArchetype, weapon_type: WeaponType) -> void:
	var group = _ensure_group_exists(group_identity, weapon_archetype, weapon_type)
	group.instantiate_weapon()

func _ensure_group_exists(group_identity: String, weapon_archetype: WeaponArchetype, weapon_type: WeaponType) -> WeaponGroup:
	for group in groups.get_children():
		if group.group_identity == group_identity:
			return group
	return _instantiate_group(group_identity, weapon_archetype, weapon_type)
	
func _instantiate_group(group_identity: String, weapon_archetype: WeaponArchetype, weapon_type: WeaponType) -> WeaponGroup:
	var weapon_group = load("res://weapon_group.tscn")
	var new_group: WeaponGroup = weapon_group.instantiate()
	new_group.init(group_identity, weapon_archetype, weapon_type, player_stats, _get_related_scene(weapon_archetype))
	groups.add_child(new_group)
	return new_group

func _get_related_scene(weapon_archetype: WeaponArchetype) -> PackedScene:
	match weapon_archetype:
		WeaponArchetype.FIREARM: return FIREARM
		WeaponArchetype.MELEE: return MELEE_WEAPON
		WeaponArchetype.ORBITAL_MELEE: return ORBITAL_MELEE_WEAPON
		_: return null
