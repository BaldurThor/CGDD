extends Node

enum TargetPriority { CLOSEST, FARTHEST, RANDOM, STRONGEST, WEAKEST}
# WEAKEST is the enemy that has the lowest health if there are enemies that have the same health it will pick the closer of them


var LEADER_BOARD_URL : String = "http://new.einardarri.is:5000/board/"
