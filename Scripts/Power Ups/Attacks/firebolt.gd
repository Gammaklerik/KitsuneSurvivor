extends Node2D

@export var title : String = "Firebolt"
@export var description : String = "Shoot out a bolt of fire dealing " + str(damage) + " fire damage."
@export var level : int = 1

@export var attack : PackedScene
@export var damage : float = 25.0
var damage_inc : float = 1.0 :
	set(value):
		damage_inc = value
		damage *= damage_inc
@export var cooldown : float = 1.0

@export var speed : float = 500.0

func activate(player: CharacterBody2D):
	var projectile : RigidBody2D = attack.instantiate()
	projectile.damage = damage
	projectile.speed = speed
	projectile.direction = player.global_position.direction_to(player.get_global_mouse_position())
	projectile.rotation_degrees = rad_to_deg(player.global_position.angle_to_point(player.get_global_mouse_position())) + 90
	projectile.position = player.global_position
	player.add_sibling(projectile)
