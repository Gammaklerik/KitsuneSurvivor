extends OptionButton

var resolutions : Array[Dictionary] = [
	{"aspect_ratio": "4:3", "width": 1024, "height": 768},
	{"aspect_ratio": "16:10", "width": 1440, "height": 900},
	{"aspect_ratio": "16:9", "width": 1280, "height": 720},
	{"aspect_ratio": "16:10", "width": 1280, "height": 800},
	{"aspect_ratio": "5:4", "width": 1280, "height": 1024},
	{"aspect_ratio": "16:10", "width": 1680, "height": 1050},
	{"aspect_ratio": "16:10", "width": 2560, "height": 1600},
	{"aspect_ratio": "21:9", "width": 3440, "height": 1440},
	{"aspect_ratio": "21:9", "width": 2560, "height": 1080},
	{"aspect_ratio": "5:4", "width": 1280, "height": 1024},
	{"aspect_ratio": "16:9", "width": 2560, "height": 1440},
	{"aspect_ratio": "16:9", "width": 1600, "height": 900},
	{"aspect_ratio": "16:9", "width": 1360, "height": 768},
	{"aspect_ratio": "16:9", "width": 1920, "height": 1080},
	{"aspect_ratio": "16:9", "width": 3840, "height": 2160},
	{"aspect_ratio": "683:384", "width": 1366, "height": 768},
	{"aspect_ratio": "16:10", "width": 1920, "height": 1200},
	{"aspect_ratio": "8:5", "width": 2880, "height": 1800},
	{"aspect_ratio": "32:9", "width": 5120, "height": 1440}
	]

func _ready():
	for resolution in resolutions:
		add_item(str(resolution.width) + " x " + str(resolution.height) + " (" + str(resolution.aspect_ratio) + ")", resolutions.find(resolution))
		if resolution.width == ProjectSettings.get_setting("display/window/size/viewport_width") && resolution.height == ProjectSettings.get_setting("display/window/size/viewport_height"):
			select(item_count - 1)

func _on_item_selected(index):
	get_window().content_scale_size = Vector2i(resolutions[get_item_id(index)].width, resolutions[get_item_id(index)].height)
	ProjectSettings.set_setting("display/window/size/viewport_width", resolutions[get_item_id(index)].width)
	ProjectSettings.set_setting("display/window/size/viewport_height", resolutions[get_item_id(index)].height)
	ProjectSettings.save_custom("res://override.cfg")
