extends Node

func toggle_debug() -> String:
	Debug.enable = false if Debug.enable else true
	
	return "Debug.enable : " + str(Debug.enable)
