extends HTTPRequest
@onready var end_stats: StatsMan = %EndStats


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	end_stats.submit.connect(send)
	
	
func send(username : String) -> void:
	if end_stats.is_valid == false:
		return
		
	var dict = end_stats.get_dict()
	dict["username"] = username
	var body = JSON.new().stringify(dict)
	var error = request(consts.LEADER_BOARD_URL,["Content-Type:application/json"],HTTPClient.METHOD_POST,body)

	if error != OK:
		print("Error", error)
