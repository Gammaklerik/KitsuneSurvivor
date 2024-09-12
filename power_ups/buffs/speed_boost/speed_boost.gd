extends Node2D

var title : String = "Speed Boost"
@export var description : String = "Increases movement speed by " + str(value * 100) + "%."
@export var level : int = 1

var value : float = 0.15

func activate(player: CharacterBody2D):
	if player != null:
		player.get_node("stats").speed_multiplier = 1 + value

func level_up():
	level += 1
	value += value / level
