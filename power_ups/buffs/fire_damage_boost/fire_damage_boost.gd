extends Node2D

var title : String = "Fire Damage Increase"
@export var description : String = "Increase the damage of fire attacks by " + str(value * 100) + "%."
@export var level : int = 1

var value : float = 0.25

func activate(player: CharacterBody2D):
	player.get_node("stats").fire_damage_inc = 1 + value

func level_up():
	level += 1
	value += value / level
