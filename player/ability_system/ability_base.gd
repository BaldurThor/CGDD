class_name Ability extends Node

var player: Player

func init(player: Player) -> void:
	self.player = player

# Overridable method for modifying player
func apply_effects(player_stats: PlayerStats, player_health: EntityHealth) -> void:
	pass
