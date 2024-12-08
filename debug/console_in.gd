extends LineEdit

# Auto complete
# Where in the list of possible matches are we
var autocomplete_index: int = 0
# All methods that are viable for autocomplete
var autocomplete_methods: Array = []
# Track if that last input was related to autocomplete
var last_input_was_autocomplete: bool = false
# Store matches of the last autocomplete so that the search doesn't have to be repeated
# when Tab is pressed multiple times
var prev_autocomplete_matches: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	autocomplete_methods = DebugCommands.get_method_list().map(func (x): return x.name)
	Debug.assigne_console_in(self)

func autocomplete() -> void:
	var matches = []
	var match_string = self.text
	
	print(last_input_was_autocomplete)
	
	# Run through matches for the last string if the user is stepping through autocomplete options
	if last_input_was_autocomplete:
		matches = prev_autocomplete_matches
	# Step through all possible matches if no input string
	elif match_string.length() == 0:
		matches = autocomplete_methods
	# Otherwise check if each possible method begins with the user string
	else:
		for method in autocomplete_methods:
			if method.begins_with(match_string):
				matches.append(method)
	
	# Store matches string for later
	prev_autocomplete_matches = matches

	# Nothing to return if no matches
	if matches.size() == 0:
		return
	
	# Go to the next possible autocomplete option if the user is Tabbing through options
	if last_input_was_autocomplete:
		autocomplete_index = wrapi(
			autocomplete_index + 1,
			0,
			matches.size()
		)
	else:
		autocomplete_index = 0
	
	# Populate console input with match
	self.text = matches[autocomplete_index]
	# Make sure the caret goes to the end of the line
	self.caret_column = 100000
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event : InputEvent):
	if event is InputEventKey and not event.is_action("debug_autocomplete"):
		last_input_was_autocomplete = false
	if event is InputEventKey and event.is_action_pressed("debug_autocomplete"):
		autocomplete()
		last_input_was_autocomplete = true
