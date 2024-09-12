extends Control

func _on_resume_button_pressed():
	get_tree().paused = false
	queue_free()

func _on_settings_button_pressed():
	var menu = preload("res://ui/settings_menu/settings_menu.tscn").instantiate()
	menu.on_main_menu = false
	add_sibling(menu)

func _on_quit_to_menu_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://ui/main_menu/main_menu.tscn")
