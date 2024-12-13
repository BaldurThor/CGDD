extends CanvasLayer

@onready var skill_bullet: TextureRect = $SkillBullet
@onready var skill_bullet_label: Label = $SkillBullet/Label
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

const SKILL_BULLET_START: Vector2 = Vector2(-84, 103)
const SKILL_BULLET_TARGET: Vector2 = Vector2(7, 103)

func _ready() -> void:
	GameManager.get_player().experience.level_up.connect(_on_player_level_up)
	GameManager.pickup_ability.connect(_on_ability_pick)

func _on_player_level_up() -> void:
	pass

func _on_ability_pick(_ability: Ability) -> void:
	pass

func fire_skill_bullet(amount: int) -> void:
	var tween = get_tree().create_tween()
	skill_bullet.position = SKILL_BULLET_START
	tween.tween_property(skill_bullet, "position", SKILL_BULLET_TARGET, 0.1)
	audio_stream_player.play()
	skill_bullet.show()
	set_skill_bullet_count(amount)

func set_skill_bullet_count(amount: int) -> void:
	skill_bullet_label.text = str(amount)

func hide_skill_bullet() -> void:
	skill_bullet.hide()
