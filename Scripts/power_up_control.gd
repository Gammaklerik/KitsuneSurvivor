extends Control

var title : String
var description : String
var level : int
var tags : Array[String]
var icon : Texture2D

var panel : Panel
var showing_description : bool = false

@onready var button : TextureButton = $icon_button
var description_panel : PackedScene = preload("res://Scenes/description_panel.tscn")

func _ready():
	button.texture_normal = icon
	button.texture_hover = icon

func _process(delta):
	if button.is_hovered() && !showing_description:
		show_description()
		showing_description = true
	else:
		if panel != null && showing_description:
			panel.queue_free()
			showing_description = false

func show_description():
	panel = description_panel.instantiate()
	panel.get_node("icon_control/icon").texture = icon
	panel.get_node("title").text = title
	panel.get_node("level").text = "Lvl. " + str(level)
	panel.get_node("description").text = description
	var tags_text : String
	for tag in tags:
		if tags.find(tag) == tags.size() - 1:
			tags_text += tag
		else:
			tags_text += tag + str(" - ")
	panel.get_node("tags").text = tags_text
	get_parent().get_parent().get_parent().add_child(panel)
