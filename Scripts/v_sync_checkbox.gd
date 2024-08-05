extends CheckBox

func _ready():
	button_pressed = ProjectSettings.get_setting("display/window/vsync/vsync_mode")

func _on_toggled(toggled_on: bool):
	ProjectSettings.set_setting("display/window/vsync/vsync_mode", toggled_on)
