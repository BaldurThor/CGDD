extends HBoxContainer

@onready var health_value: Label = $HealthValue
@onready var health_multi_positive: Label = $HealthMultiPositive
@onready var health_multi_negative: Label = $HealthMultiNegative
@onready var player_stats: PlayerStats = %PlayerStats

func _ready() -> void:
	player_stats.max_health_mod_changed.connect(_update_health_multi)
	_update_health_multi()

func _on_health_bar_health_ratio_changed(current: int, maximum: int) -> void:
	health_value.text = "%s / %s" % [current, maximum]

func _update_health_multi() -> void:
	health_multi_positive.visible = player_stats.max_health_mod > 1.0
	health_multi_negative.visible = player_stats.max_health_mod < 1.0
	
	health_multi_positive.text = "(%d%%)" % int(player_stats.max_health_mod * 100)
	health_multi_negative.text = "(%d%%)" % int(player_stats.max_health_mod * 100)
