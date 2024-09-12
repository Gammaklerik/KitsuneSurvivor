extends Node2D

var title = "aoe_name"
var description = "aoe_description"
var level = 1

var attack #: PackedScene = preload("res://power_ups/attacks/area_of_effect/[aoe_name]_aoe.tscn")
var atk_damage = 1.0
var atk_damage_inc = 1.0 :
	set(value):
		atk_damage_inc = value
		atk_damage *= atk_damage_inc
var atk_cooldown = 1.0

var aoe_area_multiplier := 1.0
var aoe_effect_duration := 0.5

# Functionality for the attack when the cooldown is up
func activate(player: CharacterBody2D):
	var aoe = attack.instantiate()
	aoe.damage = atk_damage
	aoe.area_multiplier = aoe_area_multiplier
	aoe.effect_timer.wait_time = aoe_effect_duration
	aoe.position = player.position
	player.add_sibling(aoe)

func level_up():
	level += 1
	# add tags in level up if needed
