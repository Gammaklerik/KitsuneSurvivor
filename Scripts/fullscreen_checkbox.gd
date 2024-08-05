extends CheckBox

func _ready():
	if ProjectSettings.get_setting("display/window/size/mode") == 3:
		button_pressed = true
	elif  ProjectSettings.get_setting("display/window/size/mode") == 0:
		button_pressed = false


func _on_toggled(toggled_on: bool):
	if toggled_on:
		ProjectSettings.set_setting("display/window/size/mode", 3)
	else:
		ProjectSettings.set_setting("display/window/size/mode", 0)
	ProjectSettings.save()
