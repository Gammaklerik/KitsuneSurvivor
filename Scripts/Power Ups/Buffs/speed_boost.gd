extends Node2D

var title : String = "Speed Boost"
@export var description : String = "Increases movement speed by " + str(value * 100) + "%."
@export var level : int = 1

var value : float = 0.50

var player : CharacterBody2D

func _ready():
	player = get_tree().current_scene.get_node("player")
	if player != null:
		player.get_node("stats").speed_multiplier += value
