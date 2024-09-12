extends Node2D

var title := "projectile_name"
var description := "projectile_description"
var level := 1

var attack #: PackedScene = preload("res://power_ups/attacks/projectile/[projectile_name]_projectile.tscn")
var atk_damage := 1.0
var atk_damage_inc := 1.0 :
	set(value):
		atk_damage_inc = value
		atk_damage *= atk_damage_inc
var atk_cooldown = 1.0

var proj_speed := 500.0

# Functionality for the attack when the cooldown is up
func activate(player: CharacterBody2D):
	var projectile = attack.instantiate()
	projectile.damage = atk_damage
	projectile.speed = proj_speed
	projectile.direction = player.global_position.direction_to(player.get_global_mouse_position())
	projectile.rotation_degrees = rad_to_deg(player.global_position.angle_to_point(player.get_global_mouse_position())) + 90
	projectile.position = player.global_position
	player.add_sibling(projectile)

func level_up():
	level += 1
	# add tags in level up if needed
