extends Node2D

var title = "melee_name"
var description = "melee_description"
var level = 1

var attack #: PackedScene = preload("res://power_ups/attacks/melee/[melee_name]_melee.tscn")
var atk_damage = 1.0
var atk_damage_inc = 1.0 :
	set(value):
		atk_damage_inc = value
		atk_damage *= atk_damage_inc
var atk_cooldown = 1.0

# Functionality for the attack when the cooldown is up
func activate(player: CharacterBody2D):
	var melee = attack.instantiate()
	melee.damage = atk_damage
	melee.rotation_degrees = rad_to_deg(player.global_position.angle_to_point(player.get_global_mouse_position())) + 90
	melee.position = player.global_position
	player.add_child(melee)

func level_up():
	level += 1
	# add tags in level up if needed

