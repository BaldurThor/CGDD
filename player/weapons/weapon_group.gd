class_name WeaponGroup extends Node2D

@onready var manager: Node2D = $"../.."
@onready var weapons: Node2D = $Weapons
@onready var target_range: TargetRange = $TargetRange

signal range_updated()
signal attack_speed_updated()
signal melee_strikes_updated()

## The identity of this weapon group (eg. "pistol", "shotgun"...)
var group_identity: String
var weapon_type: WeaponType = null
var player_stats: PlayerStats = null
var _scene_to_load: PackedScene = null
var weapon_archetype: WeaponGroupManager.WeaponArchetype

var primary_added_damage: int = 0
var primary_damage_mod: float = 1.0
var secondary_added_damage: int = 0
var secondary_damage_mod: float = 1.0
var added_range_mod: float = 1.0:
	set(value):
		added_range_mod = value
		range_updated.emit()
var attack_speed_mod: float = 1.0
var extra_pierce_count: int = 0
var added_crit_chance: float = 0.0
var added_crit_multiplier: float = 0.0
var added_projectiles: int = 0
var added_melee_strikes: int = 0:
	set(value):
		var delta = value - added_melee_strikes
		added_melee_strikes = value
		melee_strikes_updated.emit(delta)
var added_knockback: int = 0

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
		WeaponGroupManager.WeaponArchetype.FIREARM, WeaponGroupManager.WeaponArchetype.EXPLOSIVE_RANGED:
			player_stats.player_ranged_range_changed.connect(_update_target_range_ranged)
			update_func = _update_target_range_ranged
			player_stats.ranged_attack_speed_changed.connect(_update_attack_speed)
		WeaponGroupManager.WeaponArchetype.MELEE, WeaponGroupManager.WeaponArchetype.ORBITAL_MELEE:
			player_stats.player_melee_range_changed.connect(_update_target_range_melee)
			update_func = _update_target_range_melee
			player_stats.melee_attack_speed_changed.connect(_update_attack_speed)
	player_stats.attack_speed_updated.connect(_update_attack_speed)
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
	var new_radius = weapon_type.attack_range * player_stats.ranged_range_mod * added_range_mod
	target_range.target_range_shape.shape.radius = new_radius
	range_updated.emit()

func _update_target_range_melee() -> void:
	var new_radius = weapon_type.attack_range * player_stats.melee_range_mod * added_range_mod
	target_range.target_range_shape.shape.radius = new_radius
	range_updated.emit()

func _update_attack_speed() -> void:
	attack_speed_updated.emit()

func calculate_total_attack_speed() -> float:
	var attack_speed = weapon_type.attack_speed
	var archetype_speed_mod = 0.0
	match weapon_archetype:
		WeaponGroupManager.WeaponArchetype.FIREARM, WeaponGroupManager.WeaponArchetype.EXPLOSIVE_RANGED:
			archetype_speed_mod = player_stats.ranged_attack_speed_mod
		WeaponGroupManager.WeaponArchetype.MELEE, WeaponGroupManager.WeaponArchetype.ORBITAL_MELEE:
			archetype_speed_mod = player_stats.melee_attack_speed_mod
	attack_speed /= (player_stats.attack_speed_mod * archetype_speed_mod * attack_speed_mod)
	return attack_speed

## Returns the total pierce count for this weapon group.
func calculate_total_pierce() -> int:
	return player_stats.extra_projectile_pierce + weapon_type.pierce_count + extra_pierce_count

func get_base_damage() -> int:
	var damage = weapon_type.damage + primary_added_damage
	var damage_mod = 1.0
	match weapon_archetype:
		WeaponGroupManager.WeaponArchetype.MELEE, WeaponGroupManager.WeaponArchetype.ORBITAL_MELEE:
			damage += player_stats.added_melee_damage
		WeaponGroupManager.WeaponArchetype.FIREARM:
			damage += player_stats.added_ranged_damage
		WeaponGroupManager.WeaponArchetype.EXPLOSIVE_RANGED:
			damage += player_stats.added_explosive_damage
			damage_mod = player_stats.explosive_damage_mod
	return damage * (weapon_type.damage_effectiveness * damage_mod * player_stats.damage_mod)

func get_crit_chance() -> float:
	return weapon_type.crit_chance + player_stats.crit_chance + added_crit_chance

func get_crit_multiplier() -> float:
	return weapon_type.crit_damage + player_stats.crit_multiplier + added_crit_multiplier

func get_total_projectiles() -> int:
	return weapon_type.projectile_count + player_stats.extra_projectiles + added_projectiles

func get_explosion_radius() -> float:
	return (weapon_type.explosion_radius + player_stats.added_explosive_radius) * player_stats.explosive_radius_mod

func get_melee_strikes() -> int:
	return weapon_type.melee_strike_count + player_stats.added_melee_strikes + added_melee_strikes

func get_knockback() -> int:
	if !weapon_type.can_knockback:
		return 0
	var knockback = weapon_type.knockback + added_knockback
	match weapon_archetype:
		WeaponGroupManager.WeaponArchetype.MELEE, WeaponGroupManager.WeaponArchetype.ORBITAL_MELEE:
			knockback += player_stats.added_melee_knockback
			knockback *= player_stats.melee_knockback_mod
	return knockback

func get_secondary_knockback() -> int:
	if !weapon_type.can_knockback:
		return 0
	var knockback = weapon_type.secondary_knockback + added_knockback
	match weapon_archetype:
		WeaponGroupManager.WeaponArchetype.MELEE, WeaponGroupManager.WeaponArchetype.ORBITAL_MELEE:
			knockback += player_stats.added_melee_knockback
			knockback *= player_stats.melee_knockback_mod
	return knockback
