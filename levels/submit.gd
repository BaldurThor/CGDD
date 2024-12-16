extends HTTPRequest
@onready var end_stats: StatsMan = %EndStats


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	end_stats.submit.connect(send)
	
	
func send() -> void:
	if end_stats.is_valid == false:
		return
	var body = JSON.new().stringify(end_stats.get_dict())
	var error = request(consts.LEADER_BOARD_URL,["Content-Type:application/json"],HTTPClient.METHOD_POST,body)

	if error != OK:
		print("Error", error)
