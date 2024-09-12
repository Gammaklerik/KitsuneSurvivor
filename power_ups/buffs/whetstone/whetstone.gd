extends Node2D

var title = "Whetstone"
var description = "Sharpens your blades increasing the physical damage of attacks by " + str(value * 100) + "%."
var level = 1

var value : float = 0.25

func activate(player: CharacterBody2D):
	player.get_node("stats").physical_damage_inc = 1 + value

func level_up():
	level += 1
	value += value / level

