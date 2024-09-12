extends Node2D

@export var title : String = "Firebolt"
@export var description : String = "Shoot out a bolt of fire dealing " + str(atk_damage) + " fire damage."
@export var level : int = 1

var attack : PackedScene = preload("res://power_ups/attacks/projectile/firebolt/firebolt_projectile.tscn")
var atk_damage : float = 25.0
var atk_damage_inc : float = 1.0 :
	set(value):
		atk_damage_inc = value
		atk_damage *= atk_damage_inc
var atk_cooldown : float = 1.0

var proj_speed : float = 500.0

var dot_handler : PackedScene = preload("res://game/damage_over_time.tscn")
var dot_damage : float = 5.0
var dot_rate : float = 0.75
var dot_duration : float = 3.0

var aoe_handler : PackedScene = preload("res://power_ups/attacks/area_of_effect/firebolt/firebolt_aoe.tscn")
var aoe_damage : float = 8.0
var aoe_area_multiplier : float = 1.25
var aoe_effect_length : float = 5.0

func activate(player: CharacterBody2D):
	if level == 1:
		var projectile : RigidBody2D = new_proj(player)
		player.add_sibling(projectile)
	elif level == 2:
		var projectile : RigidBody2D = new_proj(player)
		for child in projectile.get_children():
			if child.is_class("Node2D"):
				child.scale *= 1.25
		
		projectile.dot_handler = dot_handler.instantiate()
		projectile.dot_handler.get_node("duration").wait_time = dot_duration
		projectile.dot_handler.get_node("rate").wait_time = dot_rate
		projectile.dot_handler.damage = dot_damage
		player.add_sibling(projectile)
	elif level == 3:
		# 100% larger projectile, explode on contact, create burning ground for 5 seconds
		var projectile : RigidBody2D = new_proj(player)
		for child in projectile.get_children():
			if child.is_class("Node2D"):
				child.scale *= 2
		projectile.aoe_handler = aoe_handler.instantiate()
		projectile.aoe_handler.area_multiplier = aoe_area_multiplier
		projectile.aoe_handler.get_node("effect_timer").wait_time = aoe_effect_length
		projectile.aoe_handler.damage = aoe_damage
		projectile.aoe_handler.dot_handler = dot_handler
		projectile.aoe_handler.dot_duration = dot_duration
		projectile.aoe_handler.dot_rate = dot_rate
		projectile.aoe_handler.dot_damage = dot_damage
		player.add_sibling(projectile)

func new_proj(player: CharacterBody2D):
	var proj : RigidBody2D = attack.instantiate()
	proj.damage = atk_damage * 1.05
	proj.speed = proj_speed
	proj.direction = player.global_position.direction_to(player.get_global_mouse_position())
	proj.rotation_degrees = rad_to_deg(player.global_position.angle_to_point(player.get_global_mouse_position())) + 90
	proj.position = player.global_position
	return proj

func level_up():
	level += 1
	if level == 2:
		add_to_group("dot")
	elif level == 3:
		add_to_group("aoe")
