extends Node2D

var title : String = "HP+"
@export var description : String = "Increase your health by " + str(value * 100) + "%."
@export var level : int = 1

var value : float = 0.25

func activate(player: CharacterBody2D):
	player.get_node("stats").health_multiplier = 1 + value

func level_up():
	level += 1
	value += value / level
