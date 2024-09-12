extends Node2D

var title = "Health Regen"
var description = "Health HP by " + str(value) + " per second."
var level = 1

var value : float = 1.08

func activate(player: CharacterBody2D):
	player.get_node("stats").health_regen = value

func level_up():
	level += 1
	value += 1.08
