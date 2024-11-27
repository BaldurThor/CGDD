extends Node

var _player: Player = null

# Used by the player.gd script to tell the game manager where the player is.
# Allows other scripts to access the player from wherever they are.
func assign_player(player: Player):
	_player = player

# Returns the currently assigned instance of the player. Returns null if no
# player is assigned
func get_player() -> Player:
	return _player
