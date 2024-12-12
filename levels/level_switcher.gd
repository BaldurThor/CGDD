extends Node2D

@onready var levels: Array[Node2D] = [
	$Level1,
	$Level2,
	$Level3,
	$Level4,
]

@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"

const SHOCKWAVE = preload("res://levels/transition/shockwave.tscn")

var prev_level: Node2D = null
var new_level: Node2D = null
var new_level_id: int = 1

signal level_switched

# Private signal for decoupling from the animation player
signal _level_switch

func _ready():
	GameManager.new_world_level.connect(_on_new_world_level)
	prev_level = levels[0]
	new_level = levels[0]
	levels[0].get_node("Music").play()
	_level_switch.connect(_on_level_switch)

func _on_new_world_level():
	set_level(GameManager.world_level)

func set_level(level: int) -> void:
	animation_player.play("level_transition")
	new_level_id = level
	
	var shockwave = SHOCKWAVE.instantiate()
	add_child(shockwave)
	shockwave.global_position = GameManager.get_player().global_position
	
	new_level = levels[level - 1]
	
	var prev_music: AudioStreamPlayer = prev_level.get_node("Music")
	var tween = get_tree().create_tween()
	tween.tween_property(prev_music, "volume_db", -100, 30).set_trans(Tween.TRANS_LINEAR)
	tween.tween_callback(prev_music.stop)

func transition_next_level():
	_level_switch.emit()

func _on_level_switch():
	GameManager.level_transitioning = false
	
	# Play new music
	var music: AudioStreamPlayer = new_level.get_node("Music")
	music.volume_db = 0
	music.play()
	
	# Clear previous entities
	var nodes_to_clear = get_tree().get_nodes_in_group("level_clear")
	for node in nodes_to_clear:
		node.queue_free()
	
	# Show correct level layer
	for i in range(levels.size()):
		var active = i == new_level_id - 1
		levels[i].visible = active
	
	prev_level = new_level
	
	GameManager.new_world_level_active.emit()
	level_switched.emit()
	
func stop_music() -> void:
	var music: AudioStreamPlayer = new_level.get_node("Music")
	music.stop()
