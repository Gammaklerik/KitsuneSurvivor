extends Node2D

var title : String = "Katana"
var description : String = "Swing a katana dealing " + str(atk_damage) + " physical damage."
var level : int = 1

var attack : PackedScene = preload("res://power_ups/attacks/melee/katana/katana_melee.tscn")
var atk_damage : float = 30.0
var atk_damage_inc : float = 1.0 :
	set(value):
		atk_damage_inc = value
		atk_damage *= atk_damage_inc
var atk_cooldown : float = 1.0

var dot_handler : PackedScene
var dot_damage : float
var dot_rate : float
var dot_duration : float
var bleed_chance : float

# Functionality for the attack when the cooldown is up
func activate(player: CharacterBody2D):
	var melee : Area2D = attack.instantiate()
	melee.damage = atk_damage
	melee.level = level
	melee.rotation_degrees = rad_to_deg(player.global_position.angle_to_point(player.get_global_mouse_position()))
	if dot_handler != null:
		var bleed : Node = dot_handler.instantiate()
		melee.dot_handler = bleed
		melee.bleed_chance = bleed_chance
		bleed.damage = dot_damage
		bleed.get_node("duration").wait_time = dot_duration
		bleed.get_node("rate").wait_time = dot_rate
	player.add_child(melee)

func level_up():
	level += 1
