extends CheckBox

func _ready():
	if get_window().mode == Window.MODE_FULLSCREEN:
		button_pressed = true
	elif  get_window().mode != Window.MODE_FULLSCREEN:
		button_pressed = false


func _on_toggled(toggled_on: bool):
	if toggled_on:
		get_window().mode = Window.MODE_FULLSCREEN
		ProjectSettings.set_setting("display/window/size/mode", 3)
	else:
		get_window().mode = Window.MODE_WINDOWED
		ProjectSettings.set_setting("display/window/size/mode", 0)
	
	ProjectSettings.save_custom("res://override.cfg")
