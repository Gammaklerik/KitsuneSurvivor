extends OptionButton

func _ready():
	select(get_item_index(DisplayServer.window_get_vsync_mode()))

func _on_item_selected(index):
	DisplayServer.window_set_vsync_mode(get_item_id(index))
	ProjectSettings.set_setting("display/window/vsync/vsync_mode", get_item_id(index))
	ProjectSettings.save_custom("res://override.cfg")
