extends Node2D

@export var title : String = "Lightning Bolt"
@export var description : String = "Fire out a bolt of lightning dealing " + str(atk_damage) + " lightning damage."
@export var level : int = 1

var attack : PackedScene = preload("res://power_ups/attacks/beam/lightning_bolt/lightning_bolt_beam.tscn")
var atk_damage : float = 30.0
var atk_damage_inc : float = 1.0 :
	set(value):
		atk_damage_inc = value
		atk_damage *= atk_damage_inc
var atk_cooldown : float = 2.0

func activate(player: CharacterBody2D):
	var beam : Area2D = attack.instantiate()
	beam.damage = atk_damage
	beam.position = player.position
	beam.rotation_degrees = rad_to_deg(player.global_position.angle_to_point(player.get_global_mouse_position())) + 90
	beam.level = level
	player.add_sibling(beam)

func level_up():
	level += 1
