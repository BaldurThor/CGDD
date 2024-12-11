extends LogicNode

@onready var cooldown_timer: Timer = $CooldownTimer
@onready var bullet_hell_spawner: ProjectileSpawner = $"../../BulletHellSpawner"

var _can_attack: bool = false

func evaluate() -> bool:
	return _can_attack

func execute_logic():
	cooldown_timer.start()
	_can_attack = false
	bullet_hell_spawner.spawn()

func _on_cooldown_timer_timeout() -> void:
	_can_attack = true
