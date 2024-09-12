extends Node2D

var title : String = "Kunai"
var description : String = "Toss out a fast moving kunai that deals " + str(atk_damage) + " physical damage."
var level : int = 1

var attack : PackedScene = preload("res://power_ups/attacks/projectile/kunai/kunai_projectile.tscn")
var atk_damage : float = 10.0
var atk_damage_inc : float = 1.0 :
	set(value):
		atk_damage_inc = value
		atk_damage *= atk_damage_inc
var atk_cooldown : float = 0.5

var proj_speed : float = 1000.0

var dot_handler : PackedScene
var dot_damage : float
var dot_rate : float
var dot_duration : float
var bleed_chance : float

func activate(player: CharacterBody2D):
	if level == 1:
		player.add_sibling(new_proj(player, player.global_position.direction_to(player.get_global_mouse_position())))
	if level == 2:
		var projectile_amount : int = 3
		for proj in projectile_amount:
			var rot : float = (proj * 15) - 15
			player.add_sibling(new_proj(player, player.global_position.direction_to(player.get_global_mouse_position()).rotated(deg_to_rad(rot))))
	elif level == 3:
		var projectile_amount : int = 5
		for proj in projectile_amount:
			var rot : float = (proj * 72) - 72
			
			player.add_sibling(new_proj(player, player.global_position.direction_to(player.get_global_mouse_position()).rotated(deg_to_rad(rot))))

func new_proj(player: CharacterBody2D, new_direction: Vector2):
	var new_projectile : RigidBody2D = attack.instantiate()
	new_projectile.damage = atk_damage
	new_projectile.speed = proj_speed
	new_projectile.position = player.global_position
	
	new_projectile.direction = new_direction
	new_projectile.rotation_degrees = rad_to_deg(new_direction.angle()) + 90
	if dot_handler != null:
		var bleed : Node = dot_handler.instantiate()
		new_projectile.dot_handler = bleed
		new_projectile.bleed_chance = bleed_chance
		bleed.damage = dot_damage
		bleed.get_node("duration").wait_time = dot_duration
		bleed.get_node("rate").wait_time = dot_rate
	return new_projectile

func level_up():
	level += 1
