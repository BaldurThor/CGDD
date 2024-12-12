class_name stats_man extends Node

@onready var player: Player = $"../Player"

var is_valid : bool = true

var _total_damage_taken : int = 0
var _total_damage_done : int = 0
var _kills : int = 0
var _abilities_picked : int = 0 
var _boss_kills : int = 0
var _time_played : int = 0
# the time when you win, ueed for endless mode
var _time_when_done : int = 0
var _total_xp : int = 0
var _heal_amount_regen : int = 0
var _heal_amount_medkit : int = 0
var _crits : int = 0
var _caught_fish : int = 0
var _shots_fired : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# do not count cheaters
	Debug.run_command.connect(cheat)
	# game manager signals
	GameManager.player_take_damage.connect(_took_damage)
	GameManager.enemy_take_damage.connect(_did_damage)
	GameManager.enemy_died.connect(_kill)
	GameManager.pickup_ability.connect(_got_ability)
	GameManager.boss_killed.connect(_killed_boss)
	GameManager.caught_fish.connect(_fish)
	GameManager.made_projectile.connect(_made_projectile)
	GameManager.game_win.connect(_over)
	GameManager.got_crit.connect(_got_crit)
	
	GameManager.get_player().player_stats.death.connect(_over)
	GameManager.get_player().experience.gain_experience.connect(_get_xp)
	GameManager.get_player().healed_amount.connect(_heal)

func _over() -> void:
	_time_when_done = _time_played
	print("_total_damage_taken : ", _total_damage_taken)
	print("_total_damage_done : ", _total_damage_done)
	print("_kills : ", _kills)
	print("_abilities_picked : ", _abilities_picked) 
	print("_boss_kills : ",_boss_kills)
	print("_time_played : ",_time_played)
	print("_total_xp : ",_total_xp)
	print("_heal_amount_regen : ",_heal_amount_regen)
	print("_heal_amount_medkit : ",_heal_amount_medkit)
	print("_crits : ",_crits)
	print("_caught_fish : ",_caught_fish)
	print("_shots_fired : ",_shots_fired)

func cheat() -> void:
	is_valid = false
	
func _took_damage(amount : int) -> void:
	_total_damage_taken += amount
	
func _did_damage(amount : int) -> void:
	_total_damage_done += amount

func _kill() -> void:
	_kills += 1
	
func _got_ability(_a : AbilityInfo) -> void:
	_abilities_picked +=1
	
func _killed_boss() -> void:
	_boss_kills += 1
	_kill()

func get_time_played() -> int:
	return _time_played

func _on_timer_timeout() -> void:
	_time_played += 1
	
func _get_xp(amount : int, _m : bool) -> void:
	_total_xp += amount
	
func _heal(amount : int, regen : bool) -> void:
	if regen:
		_heal_amount_regen += amount
	else:
		_heal_amount_medkit += amount
		
func _fish() -> void:
	_caught_fish += 1
	
func _got_crit() -> void:
	_crits += 1
	
func _made_projectile() -> void:
	_shots_fired += 1
	
	
	
