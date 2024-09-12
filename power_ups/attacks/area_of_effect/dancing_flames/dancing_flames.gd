extends Node2D

var title = "Dancing Flames"
var description = "Produce 3 flames that rotate around you which deal damage on contact and leave an enemy with a burn for 3.5 seconds."
var level = 1

var atk_instance : Area2D
var attack : PackedScene = preload("res://power_ups/attacks/area_of_effect/dancing_flames/dancing_flames_aoe.tscn")
var atk_damage : float = 5.0
var atk_damage_inc : float = 1.0 :
	set(value):
		atk_damage_inc = value
		atk_damage *= atk_damage_inc
var atk_cooldown : float = 0.0

var aoe_effect_duration : float = 0.5

var dot_damage : float = 3.0
var dot_duration : float = 4.5
var dot_rate : float = 0.5

var dancing_flame : PackedScene = preload("res://power_ups/attacks/area_of_effect/dancing_flames/dancing_flame.tscn")

# Functionality for the attack when the cooldown is up
func activate(player: CharacterBody2D):
	atk_instance = attack.instantiate()
	atk_instance.damage = atk_damage
	if level == 1:
		add_flames(atk_instance, 3)
		atk_instance.dot_damage = dot_damage
		atk_instance.dot_duration = dot_duration
		atk_instance.dot_rate = dot_rate
	if level == 2:
		add_flames(atk_instance, 4)
		atk_instance.dot_damage = dot_damage
		atk_instance.dot_duration = dot_duration
		atk_instance.dot_rate = dot_rate
	if level == 3:
		add_flames(atk_instance, 6)
		atk_instance.dot_damage = dot_damage
		atk_instance.dot_duration = dot_duration
		atk_instance.dot_rate = dot_rate
	player.add_child(atk_instance)

func add_flames(aoe: Area2D, flames: int):
	var rot_increment : float = 360 / flames
	for flame in flames:
		var rot_angle : float = (flame * rot_increment) - rot_increment
		var new_flame : CollisionShape2D = dancing_flame.instantiate()
		aoe.add_child(new_flame)
		new_flame.position.x += 120
		new_flame.position = new_flame.position.rotated(deg_to_rad(rot_angle))

func level_up():
	level += 1
