extends Node2D

var title : String = "Fire Damage Increase"
@export var description : String = "Increase the damage of fire attacks by " + str(value * 100) + "%."
@export var level : int = 1

var value : float = 0.25

var player : CharacterBody2D

func _ready():
	player = get_tree().current_scene.get_node("player")
	if player != null:
		player.get_node("stats").fire_damage_inc += value
