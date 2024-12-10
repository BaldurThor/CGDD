class_name PlayerCamera extends Camera2D

@export var decay: float = 0.8
@export var max_offset: Vector2
@export var noise: FastNoiseLite

@export var trauma: float = 0.0
@export var trauma_pwr: int = 2

var noise_y = 0

func _ready():
	randomize()
	noise.seed = randi()
	
	GameManager.enemy_take_damage.connect(func(amt: int=0.05): add_trauma(amt))
	GameManager.player_take_damage.connect(func(amt: int=1): add_trauma(amt))
	GameManager.explosion_occurred.connect(func(intensity: float=0.5): add_trauma(intensity))

func add_trauma(amount: float):
	amount = clamp(amount, 0, 1)
	trauma = min(trauma + amount, 1.0)

func _process(delta):
	if trauma != 0.0:
		trauma = max(trauma - decay * delta, 0.0)
		_shake()

func _shake():
	var amount = pow(trauma, trauma_pwr)
	noise_y += 1
	offset.x = max_offset.x * amount * noise.get_noise_2d(1000, noise_y)
	offset.y = max_offset.y * amount * noise.get_noise_2d(2000, noise_y)
