extends VBoxContainer

const STAT_VALUE = preload("res://menu/win/stat_value.tscn")

var end_stats: StatsMan

func _ready() -> void:
	end_stats = GameManager.get_stats_man()

func show_stats() -> void:
	for child in get_children():
		child.queue_free()
	
	_add_int_stat("Total damage taken", end_stats.get_total_damage_taken())
	_add_int_stat("Total damage done", end_stats.get_total_damage_done())
	_add_int_stat("Total kills", end_stats.get_kills())
	_add_int_stat("Abilities picked", end_stats.get_abilities_picked())
	_add_int_stat("Boss kills", end_stats.get_boss_kills())
	_add_time_stat("Time played", end_stats.get_time_played())
	_add_int_stat("Total XP", end_stats.get_total_xp())
	_add_int_stat("Health regenerated", end_stats.get_heal_amount_regen())
	_add_int_stat("Health picked up", end_stats.get_heal_amount_medkit())
	_add_int_stat("Number of crits", end_stats.get_crits())
	_add_int_stat("Fish caught", end_stats.get_caught_fish())
	_add_int_stat("Number of shots fired", end_stats.get_shots_fired())

func _add_stat(label: String, value: String) -> void:
	var stat = STAT_VALUE.instantiate()
	stat.get_node("Label").text = label
	stat.get_node("Value").text = value
	add_child(stat)

func _add_time_stat(label: String, value: int) -> void:
	var secs = value % 60
	var mins = value / 60
	_add_stat(label, "%s:%s" % [str(mins).pad_zeros(2), str(secs).pad_zeros(2)])

func _add_int_stat(label: String, value: int) -> void:
	_add_stat(label, str(value))
