extends Control

var on_main_menu : bool = true

func _ready():
	if !on_main_menu:
		$canvas/back_button.text = "Back to Game"

func _on_back_button_pressed():
	if on_main_menu:
		get_tree().change_scene_to_file("res://ui/main_menu/main_menu.tscn")
	else:
		queue_free()
