extends Control

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://game/level.tscn")

func _on_settings_button_pressed():
	get_tree().change_scene_to_file("res://ui/settings_menu/settings_menu.tscn")

func _on_quit_game_button_pressed():
	get_tree().quit()
