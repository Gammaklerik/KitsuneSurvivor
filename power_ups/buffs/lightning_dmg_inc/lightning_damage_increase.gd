extends Node2D

var title = "Lightning Potency"
var description = "Increase the damage of lightning attacks by " + str(value * 100) + "%."
var level = 1

var value : float = 0.25

func activate(player: CharacterBody2D):
	player.get_node("stats").lightning_damage_inc = 1 + value

func level_up():
	level += 1
	value += value / level
