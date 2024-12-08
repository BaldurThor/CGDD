extends Node

func toggle_debug() -> String:
	Debug.enable = not Debug.enable
	
	return "Debug.enable : " + str(Debug.enable)
