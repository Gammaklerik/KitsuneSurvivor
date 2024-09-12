extends Node2D

var title : String = "Defence"
@export var description : String = "Increase damage reduction by " + str(value * 100) + "%."
@export var level : int = 1

var value : float = 0.15

func activate(player: CharacterBody2D):
	player.get_node("stats").damage_reduction = 1.0 - value

func level_up():
	level += 1
	value += value / level
