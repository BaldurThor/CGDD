class_name Ability extends Node

var player: Player

func init(the_player: Player) -> void:
	self.player = the_player

# Overridable method for modifying player
func apply_effects(player_stats: PlayerStats) -> void:
	pass
