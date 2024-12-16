extends VBoxContainer

const WEAPON_STAT = preload("res://menu/win/weapon_stat.tscn")

func _ready() -> void:
	clear()

func clear() -> void:
	for child in get_children():
		child.queue_free()

func show_stats() -> void:
	clear()
	var groups = GameManager.get_player().weapon_group_manager.groups
	for group in groups.get_children():
		var info = WEAPON_STAT.instantiate()
		info.init(group)
		add_child(info)
