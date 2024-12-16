class_name StatsMan extends Node

@onready var player: Player = $"../Player"
@onready var http_request: HTTPRequest = $HTTPRequest

var is_valid : bool = true

var _total_damage_taken: int = 0
var _total_damage_done: int = 0
var _kills: int = 0
var _abilities_picked: int = 0 
var _boss_kills: int = 0
var _total_xp: int = 0
var _heal_amount_regen: int = 0
var _heal_amount_medkit: int = 0
var _crits: int = 0
var _caught_fish: int = 0
var _shots_fired: int = 0

var _kill_cthulhu : bool = false

signal submit(username : String)

func _enter_tree() -> void:
	GameManager.assign_stats_man(self)

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
	GameManager.game_win.connect(_win)
	GameManager.got_crit.connect(_got_crit)
	
	GameManager.get_player().player_stats.death.connect(_over)
	GameManager.get_player().experience.gain_experience.connect(_get_xp)
	GameManager.get_player().healed_amount.connect(_heal)

func _over() -> void:
	GameManager._time_when_done = GameManager._time_played

func _win() -> void:
	_kill_cthulhu = true
	_over()

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
	
func _killed_boss(_boss: Boss) -> void:
	_boss_kills += 1
	_kill()

func get_time_played() -> int:
	return GameManager._time_played

func _on_timer_timeout() -> void:
	GameManager._time_played += 1
	
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

func get_total_damage_taken() -> int:
	return _total_damage_taken

func get_total_damage_done() -> int:
	return _total_damage_done

func get_kills() -> int:
	return _kills

func get_abilities_picked() -> int:
	return _abilities_picked 

func get_boss_kills() -> int:
	return _boss_kills

func get_time_when_done() -> int:
	return GameManager._time_when_done

func get_total_xp() -> int:
	return _total_xp

func get_heal_amount_regen() -> int:
	return _heal_amount_regen

func get_heal_amount_medkit() -> int:
	return _heal_amount_medkit

func get_crits() -> int:
	return _crits

func get_caught_fish() -> int:
	return _caught_fish

func get_shots_fired() -> int:
	return _shots_fired


func get_dict() -> Dictionary:
	
	var level = GameManager.get_player().experience.current_level
	
	var dict : Dictionary = {
	"total_damage_taken" : _total_damage_taken,
	"total_damage_done" : _total_damage_done,
	"kills" : _kills,
	"abilities_picked" : _abilities_picked, 
	"boss_kills" : _boss_kills,
	"total_xp" : _total_xp,
	"heal_amount_regen" : _heal_amount_regen,
	"heal_amount_medkit" : _heal_amount_medkit,
	"crits" : _crits,
	"caught_fish" : _caught_fish,
	"shots_fired" : _shots_fired,
	"level" : level,
	"finished" : _kill_cthulhu
	}
	return dict
