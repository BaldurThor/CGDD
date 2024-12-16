extends HBoxContainer

@onready var panel_container: PanelContainer = $PanelContainer
@onready var v_box_container: VBoxContainer = $PanelContainer/MarginContainer/VBoxContainer
@onready var texture_rect: TextureRect = $Button/TextureRect

const WEAPON_STAT_LABEL = preload("res://menu/win/weapon_stat_label.tscn")

var weapon_group: WeaponGroup

func init(group: WeaponGroup) -> void:
	weapon_group = group

func _ready() -> void:
	texture_rect.texture = weapon_group.weapon_type.sprite
	match weapon_group.weapon_archetype:
		WeaponGroupManager.WeaponArchetype.FIREARM:
			_init_gun()
		WeaponGroupManager.WeaponArchetype.MELEE, WeaponGroupManager.WeaponArchetype.ORBITAL_MELEE:
			_init_melee()
		WeaponGroupManager.WeaponArchetype.EXPLOSIVE_RANGED:
			_init_explosive()
	if weapon_group.group_identity == "frag_grenade":
		_init_frag_grenade()

func _process(_delta: float) -> void:
	panel_container.global_position = get_global_mouse_position() - panel_container.size

func _init_melee() -> void:
	v_box_container.add_child(_init_damage())
	v_box_container.add_child(_init_attack_speed())
	v_box_container.add_child(_init_crit_chance())
	v_box_container.add_child(_init_crit_multi())
	v_box_container.add_child(_init_knockback())
	v_box_container.add_child(_init_strikes())
	v_box_container.add_child(_init_range())
	
func _init_gun() -> void:
	v_box_container.add_child(_init_damage())
	v_box_container.add_child(_init_attack_speed())
	v_box_container.add_child(_init_projectiles())
	v_box_container.add_child(_init_pierce())
	v_box_container.add_child(_init_crit_chance())
	v_box_container.add_child(_init_crit_multi())
	v_box_container.add_child(_init_range())
	
func _init_explosive() -> void:
	v_box_container.add_child(_init_damage())
	v_box_container.add_child(_init_attack_speed())
	v_box_container.add_child(_init_explosion_radius())
	v_box_container.add_child(_init_range())

func _init_damage() -> Label:
	var label = WEAPON_STAT_LABEL.instantiate()
	label.text = "Damage: %s" % weapon_group.get_base_damage()
	return label

func _init_attack_speed() -> Label:
	var label = WEAPON_STAT_LABEL.instantiate()
	label.text = "Attack speed: %s" % snappedf(weapon_group.calculate_total_attack_speed(), 0.01)
	return label

func _init_projectiles() -> Label:
	var label = WEAPON_STAT_LABEL.instantiate()
	label.text = "Projectiles: %s" % weapon_group.get_total_projectiles()
	return label

func _init_crit_chance() -> Label:
	var label = WEAPON_STAT_LABEL.instantiate()
	label.text = "Crit chance: %s%%" % snappedf((weapon_group.get_crit_chance() * 100), 0.01)
	return label

func _init_crit_multi() -> Label:
	var label = WEAPON_STAT_LABEL.instantiate()
	label.text = "Crit multiplier: %s%%" % snappedf((weapon_group.get_crit_multiplier() * 100), 0.01)
	return label

func _init_range() -> Label:
	var label = WEAPON_STAT_LABEL.instantiate()
	label.text = "Attack range: %s" % weapon_group.get_attack_range()
	return label

func _init_pierce() -> Label:
	var label = WEAPON_STAT_LABEL.instantiate()
	label.text = "Pierce count: %s" % weapon_group.calculate_total_pierce()
	return label

func _init_knockback() -> Label:
	var label = WEAPON_STAT_LABEL.instantiate()
	label.text = "Knockback: %s" % weapon_group.get_knockback()
	return label

func _init_strikes() -> Label:
	var label = WEAPON_STAT_LABEL.instantiate()
	label.text = "Strikes: %s" % weapon_group.get_melee_strikes()
	return label

func _init_explosion_radius() -> Label:
	var label = WEAPON_STAT_LABEL.instantiate()
	label.text = "Explosion radius: %s" % weapon_group.get_explosion_radius()
	return label

func _init_frag_grenade() -> void:
	var shrap_dmg_label = WEAPON_STAT_LABEL.instantiate()
	shrap_dmg_label.text = "Shrapnel damage: %s" % weapon_group.get_secondary_damage()
	v_box_container.add_child(shrap_dmg_label)
	var pierce_label = WEAPON_STAT_LABEL.instantiate()
	pierce_label.text = "Shrapnel pierce: %s" % weapon_group.calculate_total_pierce()
	v_box_container.add_child(pierce_label)
	var proj_label = WEAPON_STAT_LABEL.instantiate()
	proj_label.text = "Shrapnel projectiles: %s" % weapon_group.get_total_projectiles()
	v_box_container.add_child(proj_label)
	var crit_label = WEAPON_STAT_LABEL.instantiate()
	crit_label.text = "Shrapnel crit chance: %s" % (weapon_group.get_crit_chance() * 100)
	v_box_container.add_child(crit_label)
	var crit_mul_label = WEAPON_STAT_LABEL.instantiate()
	crit_mul_label.text = "Shrapnel crit multiplier: %s" % (weapon_group.get_crit_multiplier() * 100)
	v_box_container.add_child(crit_mul_label)

func _on_button_mouse_entered() -> void:
	panel_container.visible = true


func _on_button_mouse_exited() -> void:
	panel_container.visible = false
