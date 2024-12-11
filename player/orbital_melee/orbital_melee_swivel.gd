class_name OrbitalMeleeSwivel extends Node2D

var weapon_type: WeaponType = null
var player_stats: PlayerStats = null

@onready var melee: Melee = $".."
@onready var melee_target_range: Area2D = $"../MeleeTargetRange"
@onready var orbital_melee: Melee = $".."

func _ready() -> void:
	self.weapon_type = melee.weapon_type
	self.player_stats = melee.player_stats
	orbital_melee.player_stats.player_melee_range_changed.connect(_reevaluate_child_positions)
	orbital_melee.player_stats.player_melee_strike_count_changed.connect(_reevaluate_child_count)
	var initial_count = orbital_melee.weapon_type.melee_strike_count + orbital_melee.player_stats.added_melee_strikes
	_reevaluate_child_count(initial_count)
	_reevaluate_child_positions()
	_reevaluate_child_radii()

func _process(delta: float) -> void:
	rotate(delta * player_stats.attack_speed_mod * player_stats.melee_attack_speed_mod)

## Delta = the modification to the number of child elements
func _reevaluate_child_count(delta: int) -> void:
	if delta == 0:
		return
	elif delta > 0:
		for i in range(delta):
			var new_weapon = orbital_melee.melee_weapon_scene.instantiate()
			add_child(new_weapon)
	elif delta < 0:
		var children = get_children()
		for i in range(-delta):
			children[i].queue_free()
	_reevaluate_child_positions()
	_reevaluate_child_radii()

func _get_radius() -> float:
	return orbital_melee.weapon_type.attack_range * orbital_melee.player_stats.melee_range_mod

func _reevaluate_child_radii() -> void:
	var children: Array[Area2D] = []
	children.assign(get_children())
	for child in children:
		child.scale = Vector2.ONE * player_stats.melee_range_mod

func _reevaluate_child_positions() -> void:
	var children = get_children()
	var radius = _get_radius()
	for i in range(children.size()):
		var child = children[i]
		var theta = (2 * PI) * (float(i) / children.size())
		var pos = Vector2(cos(theta), sin(theta)) * radius
		child.position = pos
		var dir = Vector2(-sin(theta), cos(theta))
		#child.look_at(dir)
		child.rotation = atan2(dir.y, dir.x)
	_reevaluate_child_radii()
