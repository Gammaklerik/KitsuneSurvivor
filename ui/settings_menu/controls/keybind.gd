extends Button

var action_name : String
var bind_key : InputEventKey

var listening : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	action_name = get_parent().name
	change_text()

func change_text():
	bind_key = InputMap.action_get_events(action_name)[0]
	text = str(OS.get_keycode_string(bind_key.physical_keycode))

func _on_pressed():
	listening = true

func _input(event):
	if listening:
		if event is InputEventKey:
			InputMap.action_erase_event(action_name, bind_key)
			InputMap.action_add_event(action_name, event)
			change_text()
			listening = false
