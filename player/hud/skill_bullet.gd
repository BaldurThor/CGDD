class_name SkillBullet extends TextureRect

@onready var label: Label = $Label
@onready var experience: Experience = %Experience
@onready var ability_selector: AbilitySelector = %AbilitySelector
@onready var skill_bullet_sfx: AudioStreamPlayer = $SkillBulletSFX
@onready var new_level_sfx: AudioStreamPlayer = $NewLevelSFX

const SKILL_BULLET_START: Vector2 = Vector2(-84, 103)
const SKILL_BULLET_TARGET: Vector2 = Vector2(7, 103)

var last_skill_point_count: int = 0

func _process(delta: float) -> void:
	var current_skill_point = ability_selector.ability_queue.size()
	
	set_skill_bullet_count(current_skill_point)
	
	if current_skill_point == 0:
		hide_skill_bullet()
	
	if last_skill_point_count == 0 and current_skill_point > 0:
		fire_skill_bullet()
	elif current_skill_point > 0 and current_skill_point != last_skill_point_count:
		new_level_sfx.play()
	
	last_skill_point_count = current_skill_point

func fire_skill_bullet() -> void:
	var tween = get_tree().create_tween()
	position = SKILL_BULLET_START
	tween.tween_property(self, "position", SKILL_BULLET_TARGET, 0.1)
	skill_bullet_sfx.play()
	show()

func set_skill_bullet_count(amount: int) -> void:
	label.text = str(amount)

func hide_skill_bullet() -> void:
	hide()
