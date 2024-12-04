extends Node

var _player: Player = null
var _enemy_manager: EnemyManager = null

# Global game events
signal enemy_take_damage(amount: int)
signal player_take_damage(amount: int)
signal explosion_occurred(intensity: float)

# Used by the player.gd script to tell the game manager where the player is.
# Allows other scripts to access the player from wherever they are.
func assign_player(player: Player):
	_player = player

# Returns the currently assigned instance of the player. Returns null if no
# player is assigned
func get_player() -> Player:
	return _player

func assign_enemy_manager(enemy_manager: EnemyManager) -> void:
	_enemy_manager = enemy_manager

func get_enemy_manager() -> EnemyManager:
	return _enemy_manager
