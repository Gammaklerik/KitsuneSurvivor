extends Node2D

var title := "attack_name"
var description := "attack_description"
var level := 1

var attack #: PackedScene = preload("res://power_ups/attacks")
var atk_damage := 1.0
var atk_damage_inc := 1.0 :
	set(value):
		atk_damage_inc = value
		atk_damage *= atk_damage_inc
var atk_cooldown := 1.0

# Functionality for the attack when the cooldown is up
func activate(player: CharacterBody2D):
	pass

func level_up():
	level += 1
	# add tags in level up if needed
