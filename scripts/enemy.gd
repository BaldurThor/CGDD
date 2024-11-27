extends CharacterBody2D

var player: Player = null

var enemy_type: EnemyType = null
		
func initialize(start_position):
	self.position = start_position

func _ready() -> void:
	player = GameManager.get_player()

func _physics_process(delta: float) -> void:
	# Don't update if the script is running in the editor (required since
	# this is marked as a tool script, meaning it runs in the editor)
	if Engine.is_editor_hint():
		return
	
	# Make sure a player is present
	if !player:
		return
	
	# Move towards the player
	var dir = (player.global_position - global_position).normalized()
	move_and_collide(dir * 1.0)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	
	# Show a warning if this enemy is not given a time
	if enemy_type == null:
		warnings.append("Missing enemy type")
	
	return warnings
