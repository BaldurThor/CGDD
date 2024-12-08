extends Node

func toggle_debug() -> void:
	Debug.enable = false if Debug.enable else true
