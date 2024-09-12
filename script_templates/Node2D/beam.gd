extends Node2D

var title = "beam_name"
var description = "beam_description"
var level = 1

var attack #: PackedScene = preload("res://power_ups/attacks/beam/[beam_name]_beam.tscn")
var atk_damage = 1.0
var atk_damage_inc = 1.0 :
	set(value):
		atk_damage_inc = value
		atk_damage *= atk_damage_inc
var atk_cooldown = 1.0

# Functionality for the attack when the cooldown is up
func activate(player: CharacterBody2D):
	var beam = attack.instantiate()
	beam.damage = atk_damage
	beam.direction = player.global_position.direction_to(player.get_global_mouse_position())
	beam.position = player.position
	beam.rotation_degrees = rad_to_deg(player.global_position.angle_to_point(player.get_global_mouse_position())) + 90
	player.add_sibling(beam)

func level_up():
	level += 1
	# add tags in level up if needed
