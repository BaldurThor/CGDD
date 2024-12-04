extends TextureRect

@export var decay: float = 0.8

var damage_indicator_state: float:
	set(value):
		damage_indicator_state = clamp(value, 0.0, 1.0)

func _ready() -> void:
	GameManager.player_take_damage.connect(_on_player_take_damage)

func _on_player_take_damage(amount: int):
	var player = GameManager.get_player()
	damage_indicator_state += float(amount) / player.player_stats.max_health

func _process(delta: float) -> void:
	modulate.a = damage_indicator_state
	damage_indicator_state -= decay * delta
