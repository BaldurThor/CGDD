extends VBoxContainer

const STAT_VALUE = preload("res://menu/win/stat_value.tscn")

var player_stats: PlayerStats = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_stats = GameManager.get_player().player_stats

func show_stats() -> void:
	clear()

	_add_blank_stat("Player")
	_add_int_stat("Max Health", player_stats.max_health)
	_add_float_stat("Max Health Multiplier", player_stats.max_health_mod, "max_health_mod")
	_add_int_stat("Armor", player_stats.get_armor() - 1, "armor")
	_add_int_stat("Passive regen", player_stats.get_regen_amount(), "regen")
	_add_int_stat("Movement speed", int(player_stats.movement_speed))
	_add_float_stat("Movement speed multiplier", player_stats.movement_speed_mod)
	_add_float_stat("Dodge chance", player_stats.get_dodge_chance(), "dodge")
	_add_float_stat("Damage multiplier", player_stats.damage_mod, "damage_mod")
	_add_float_stat("Crit Chance", player_stats.crit_chance, "crit_chance")
	_add_float_stat("Crit Multiplier", player_stats.crit_multiplier, "crit_multiplier")
	_add_int_stat("Item absorb radius", int(player_stats.item_absorb_range * player_stats.item_absorb_range_mod), "item_absorb")
	_add_blank_stat("Guns")
	_add_int_stat("Added damage", player_stats.added_gun_damage, "added_damage")
	_add_int_stat("Extra projectiles", player_stats.extra_projectiles, "extra_projectiles")
	_add_int_stat("Extra pierce", player_stats.extra_projectile_pierce, "pierce")
	_add_blank_stat("Ranged")
	_add_float_stat("Range multiplier", player_stats.ranged_range_mod, "ranged_range_mod")
	_add_float_stat("Projectile spread", player_stats.ranged_spread_mod, "ranged_spread_mod")
	_add_blank_stat("Melee")
	_add_int_stat("Added damage", player_stats.added_melee_damage, "added_damage")
	_add_int_stat("Added strikes", player_stats.added_melee_strikes, "added_melee_strikes")
	_add_int_stat("Added knockback", player_stats.added_melee_knockback, "knockback")
	_add_float_stat("Range multiplier", player_stats.melee_range_mod)
	_add_float_stat("Attack speed multiplier", player_stats.melee_attack_speed_mod)
	_add_float_stat("Knockback multiplier", player_stats.melee_knockback_mod)
	_add_blank_stat("Explosive")
	_add_int_stat("Added damage", player_stats.added_explosive_damage, "added_damage")
	_add_int_stat("Added radius", int(player_stats.added_explosive_radius))
	_add_float_stat("Radius multiplier", float(player_stats.explosive_radius_mod), "explosive_radius_mod")

func clear() -> void:
	for child in get_children():
		child.queue_free()

func _add_stat(label: String, value: String, tag: String = "") -> void:
	var stat = STAT_VALUE.instantiate()
	if tag != "":
		stat.hover_text_content = AbilityTagManager.get_tag_description(tag)
	stat.get_node("Label").text = label
	stat.get_node("Value").text = value
	add_child(stat)

func _add_blank_stat(label: String) -> void:
	_add_stat(label, "")

func _add_int_stat(label: String, value: int, tag: String = "") -> void:
	_add_stat(label, str(value), tag)

func _add_float_stat(label: String, value: float, tag: String = "") -> void:
	_add_stat(label, "%d%%" % int(value * 100), tag)
