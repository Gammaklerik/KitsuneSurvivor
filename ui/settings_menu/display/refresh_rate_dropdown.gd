extends OptionButton

var refresh_rates : Array[float] = [60, 100, 120, 144, 175]
@onready var mon_refresh_rate : float = DisplayServer.screen_get_refresh_rate(DisplayServer.get_primary_screen())

func _ready():
	for r in refresh_rates:
		if r <= mon_refresh_rate:
			add_item(str(r))
			select(refresh_rates.find(ProjectSettings.get_setting("physics/common/physics_ticks_per_second")))
			item_selected.emit()

func _on_item_selected(index):
	Engine.physics_ticks_per_second = int(get_item_text(index))
	ProjectSettings.set_setting("physics/common/physics_ticks_per_second", int(get_item_text(index)))
	ProjectSettings.save_custom("res://override.cfg")
	
