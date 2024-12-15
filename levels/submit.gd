extends HTTPRequest


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DebugCommands.test.connect(send)
	
	
func send() -> void:
	var body = JSON.new().stringify({"name": "Godette"})
	var error = request("http://127.0.0.1:5000/board/",["Content-Type:application/json"],HTTPClient.METHOD_POST,body)

	if error != OK:
		print("Error", error)
