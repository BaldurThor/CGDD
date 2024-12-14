class_name SkillBullet extends TextureRect

@onready var label: Label = $Label
@onready var experience: Experience = %Experience
@onready var ability_selector: AbilitySelector = %AbilitySelector
@onready var skill_bullet_sfx: AudioStreamPlayer = $SkillBulletSFX
@onready var new_level_sfx: AudioStreamPlayer = $NewLevelSFX

const SKILL_BULLET_START: Vector2 = Vector2(-84, 103)
const SKILL_BULLET_TARGET: Vector2 = Vector2(15, 103)

var last_skill_point_count: int = 0
var in_transition: bool = false
var timer: float = 0.0

func _process(delta: float) -> void:
	var current_skill_point = ability_selector.ability_queue.size()
	timer += delta
	
	if not in_transition:
		scale = Vector2.ONE + Vector2.ONE * (abs(sin(timer * 8)) ** 4) * 0.25
	
	set_skill_bullet_count(current_skill_point)
	
	if current_skill_point == 0:
		hide_skill_bullet()
	
	if last_skill_point_count == 0 and current_skill_point > 0:
		fire_skill_bullet()
	elif current_skill_point > 0 and current_skill_point != last_skill_point_count:
		new_level_sfx.play()
	
	last_skill_point_count = current_skill_point

# Shows the indicator of the amount of skill points the player currently has
func fire_skill_bullet() -> void:
	in_transition = true
	var tween = get_tree().create_tween()
	position = SKILL_BULLET_START
	tween.tween_property(self, "position", SKILL_BULLET_TARGET, 0.1)
	tween.tween_callback(func(): in_transition = false)
	skill_bullet_sfx.play()
	show()

func set_skill_bullet_count(amount: int) -> void:
	label.text = str(amount)

func hide_skill_bullet() -> void:
	hide()
