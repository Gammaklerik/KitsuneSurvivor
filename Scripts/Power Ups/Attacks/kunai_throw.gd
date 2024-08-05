extends Node2D

@export var title : String = "Kunai"
@export var description : String = "Toss out a fast moving kunai that deals " + str(damage) + " physical damage."
@export var level : int = 1

@export var attack : PackedScene
@export var damage : float = 10.0
var damage_inc : float = 1.0 :
	set(value):
		damage_inc = value
		damage *= damage_inc
@export var cooldown : float = 0.5

@export var speed : float = 1000.0

func activate(player: CharacterBody2D):
	var projectile : RigidBody2D = attack.instantiate()
	projectile.damage = damage
	projectile.speed = speed
	projectile.position = player.global_position
	projectile.direction = player.global_position.direction_to(player.get_global_mouse_position())
	projectile.rotation_degrees = rad_to_deg(player.global_position.angle_to_point(player.get_global_mouse_position())) + 90
	if level == 1:
		pass
	elif level == 2:
		var projectile_02 : RigidBody2D = attack.instantiate()
		var projectile_03 : RigidBody2D = attack.instantiate()
		projectile_02.damage = damage
		projectile_02.speed = speed
		projectile_02.position = player.global_position
		projectile_03.damage = damage
		projectile_03.speed = speed
		projectile_03.position = player.global_position
		
		var proj_02_target : Vector2 = player.get_global_mouse_position().rotated(deg_to_rad(15))
		projectile_02.direction = player.global_position.direction_to(proj_02_target)
		projectile_02.rotation_degrees = rad_to_deg(player.global_position.angle_to_point(proj_02_target)) + 90
		var proj_03_target : Vector2 = player.get_global_mouse_position().rotated(deg_to_rad(-15))
		projectile_03.direction = player.global_position.direction_to(proj_03_target)
		projectile_03.rotation_degrees = rad_to_deg(player.global_position.angle_to_point(proj_03_target)) + 90
		
		print("3 Target: " + str(proj_03_target) + "\n2 Target: " + str(proj_02_target))
		
		player.add_sibling(projectile_02)
		player.add_sibling(projectile_03)
	elif level == 3:
		pass
	player.add_sibling(projectile)
