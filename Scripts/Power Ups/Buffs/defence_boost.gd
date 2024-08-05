extends Node2D

var title : String = "Defence"
@export var description : String = "Increase damage reduction by " + str(value * 100) + "%."
@export var level : int = 1

var value : float = 0.15

var player : CharacterBody2D

func _ready():
	player = get_tree().current_scene.get_node("player")
	if player != null:
		player.get_node("stats").damage_reduction -= value
