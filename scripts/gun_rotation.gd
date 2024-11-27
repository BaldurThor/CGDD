extends Node2D


func find_closest_enemy():
	var enemies = get_node("/root/Main/Enemies").get_children()
	var closest = null
	var player = GameManager.get_player()
	for enemy in enemies:
		if closest == null:
			closest = enemy
		elif player.position.distance_to(closest.position) > player.position.distance_to(enemy.position):
			closest = enemy
	return closest

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var enemy = find_closest_enemy()
	if enemy != null:
		look_at(enemy.position)
