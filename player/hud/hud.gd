extends CanvasLayer

@onready var armor_indicator: Label = $Indicators/ArmorIndicator/Label
@onready var armor_negative_indicator: Label = $Indicators/ArmorIndicator/LabelNegative
@onready var armor_positive_indicator: Label = $Indicators/ArmorIndicator/LabelPositive
@onready var dodge_indicator: Label = $Indicators/DodgeIndicator/Label
@onready var dodge_negative_indicator: Label = $Indicators/DodgeIndicator/LabelNegative
@onready var dodge_positive_indicator: Label = $Indicators/DodgeIndicator/LabelPositive
@onready var player_stats: PlayerStats = %PlayerStats

func _ready() -> void:
	player_stats.armor_changed.connect(_update_armor)
	player_stats.max_armor_changed.connect(_update_armor)
	player_stats.dodge_chance_changed.connect(_update_dodge)
	player_stats.max_dodge_chance_changed.connect(_update_dodge)
	_update_armor()
	_update_dodge()

func _update_armor() -> void:
	armor_negative_indicator.visible = player_stats.armor < 0
	armor_positive_indicator.visible = player_stats.armor > player_stats.absolute_max_armor
	
	if player_stats.armor < 0:
		armor_indicator.text = "0"
		armor_negative_indicator.text = "(%d)" % (player_stats.armor - 1)
	elif player_stats.armor > player_stats.absolute_max_armor:
		armor_indicator.text = "%d" % (player_stats.absolute_max_armor - 1)
		armor_positive_indicator.text = "(+%d)" % (player_stats.armor - player_stats.absolute_max_armor - 1)
	else:
		armor_indicator.text = "%d" % (player_stats.armor - 1)

func _update_dodge() -> void:
	dodge_negative_indicator.visible = player_stats.dodge_chance < 0
	dodge_positive_indicator.visible = player_stats.dodge_chance > player_stats.absolute_max_dodge
	
	if player_stats.dodge_chance < 0:
		dodge_indicator.text = "0%"
		dodge_negative_indicator.text = "(%d%%)" % int(player_stats.dodge_chance * 100)
	elif player_stats.dodge_chance > player_stats.absolute_max_dodge:
		dodge_indicator.text = "%d%%" % int(player_stats.absolute_max_dodge * 100)
		dodge_positive_indicator.text = "(+%d%%)" % int((player_stats.dodge_chance - player_stats.absolute_max_dodge) * 100)
	else:
		dodge_indicator.text = "%d%%" % int(player_stats.dodge_chance * 100)
