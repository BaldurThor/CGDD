extends VBoxContainer

enum Mode {
	PLAYER,
	RUN,
}

@onready var player_stats: VBoxContainer = $ScrollContainer/PlayerStats
@onready var run_stats: VBoxContainer = $ScrollContainer/RunStats

var active: VBoxContainer

var mode: Mode = Mode.PLAYER:
	set(value):
		if value == mode:
			return
		mode = value
		show_stats()

func _ready() -> void:
	active = player_stats

func show_stats() -> void:
	active.clear()
	active.hide()
	match mode:
		Mode.PLAYER:
			player_stats.show_stats()
			active = player_stats
		Mode.RUN:
			run_stats.show_stats()
			active = run_stats
	active.show()


func _on_player_stats_button_button_up() -> void:
	mode = Mode.PLAYER


func _on_run_stats_button_button_up() -> void:
	mode = Mode.RUN
