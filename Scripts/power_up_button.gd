extends Button

@export var power_ups_list : Node
var power_up : PackedScene
@onready var parent_panel : Panel = get_parent()

var player : CharacterBody2D

func _ready():
	power_up = power_ups_list.powers.pick_random()
	var power_up_info = power_up.instantiate()
	parent_panel.get_node("icon_control/icon").texture = power_up_info.get_node("icon").texture
	parent_panel.get_node("title").text = power_up_info.title
	parent_panel.get_node("description").text = power_up_info.description
	var tags_text : String
	for tag in power_up_info.get_groups():
		if power_up_info.get_groups().find(tag) == power_up_info.get_groups().size() - 1:
			tags_text += tag
		else:
			tags_text += tag + str(" - ")
	parent_panel.get_node("tags").text = tags_text
	
	player = get_tree().current_scene.get_node("player")
	
	connect("pressed", get_parent().get_parent().get_parent().get_parent()._on_power_up_selection)

func _on_pressed():
	if player != null:
		player.power_up(power_up)
	get_parent().get_parent().get_parent().queue_free()
