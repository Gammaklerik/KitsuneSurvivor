extends Node2D

var title := "buff_name"
var description := "buff_description"
var level := 1

var value #: float

var player #: CharacterBody2D

func _ready():
	player = get_tree().current_scene.get_node("player")
	#if player != null:
	#	player.get_node("stats").[stat] += value

func level_up():
	level += 1
	#if player != null:
	#	player.get_node("stats").[stat] += [value increase equation]
