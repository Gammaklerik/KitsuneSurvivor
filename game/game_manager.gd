extends Node

@export var enemies : Array[PackedScene]

@onready var health_drop : PackedScene = preload("res://game/health_drop.tscn")
var enemies_killed : int = 0
@onready var session_timer : Timer = $session_timer
@onready var spawn_timer : Timer = $spawn_timer
var seconds_alive : int = 0

var wave_list : Array[RigidBody2D]

@export var camera : Camera2D
@export var player : CharacterBody2D
@onready var player_stats : Node = player.get_node("stats")

@onready var nav_region : NavigationRegion2D = $nav_region
var spawn_region : Dictionary = {"max_x" : 0, "min_x" : 0, "max_y" : 0, "min_y" : 0}

var power_up_canvas : PackedScene = preload("res://ui/in_game/level_up/level_up_canvas.tscn")
var pause_menu : PackedScene = preload("res://ui/in_game/pause_menu/pause_menu.tscn")
var power_up_inventory : PackedScene = preload("res://ui/in_game/player/inventory/player_inventory.tscn")
var power_up_control_node : PackedScene = preload("res://ui/in_game/player/inventory/inventory_control.tscn")
var inventory_open : bool = false
var death_screen : PackedScene = preload("res://ui/in_game/lose_screen/death_screen.tscn")

func _ready():
	for vert in nav_region.navigation_polygon.get_vertices():
		if vert.x > spawn_region.max_x:
			spawn_region.max_x = vert.x
		if vert.x < spawn_region.min_x || spawn_region.min_x == 0:
			spawn_region.min_x = vert.x
		
		if vert.y > spawn_region.max_y:
			spawn_region.max_y = vert.y
		if vert.y < spawn_region.min_y || spawn_region.min_x == 0:
			spawn_region.min_y = vert.y
	
	spawn_wave(2 , 4)

func spawn_wave(min: int, max: int):
	var wave_size : int = randi_range(min, max)
	for enemy in wave_size:
		var enemy_instance = enemies.pick_random().instantiate()
		add_child(enemy_instance)
		enemy_instance.position = get_spawn_position()
		wave_list.append(enemy_instance)

func get_spawn_position():
	var spawn_position : Vector2
	spawn_position = Vector2(randf_range(spawn_region.min_x, spawn_region.max_x), randf_range(spawn_region.min_y, spawn_region.max_y))
	
	# if the random spawn position is within the given x and y range of the camera, then the position is rerolled
	while spawn_invalid(spawn_position):
		spawn_position = Vector2(randf_range(spawn_region.min_x, spawn_region.max_x), randf_range(spawn_region.min_y, spawn_region.max_y))
	
	return spawn_position

func spawn_invalid(pos: Vector2):
	if pos.x < camera.get_screen_center_position().x + 600 && pos.x > camera.get_screen_center_position().x - 600:
		if pos.y < camera.get_screen_center_position().y + 600 && pos.y > camera.get_screen_center_position().y - 600:
			return true
		else:
			return false
	else:
		return false

func _on_enemy_death(enemy):
	if randi_range(1, 100) <= 10:
		var drop = health_drop.instantiate()
		drop.position = enemy.position
		add_sibling(drop)
	wave_list.erase(enemy)
	enemies_killed += 1
	if wave_list.size() == 0:
		spawn_wave(2, 4)

func _on_player_level_up():
	get_tree().paused = true
	add_child(power_up_canvas.instantiate())

func _on_power_up_selection():
	get_tree().paused = false

func _input(event):
	match event.get_class():
		"InputEventKey":
			if event.is_action_pressed("ui_cancel"):
				if inventory_open:
					get_node("power_up_inventory").queue_free()
					inventory_open = false
					get_tree().paused = false
				elif !inventory_open && !get_tree().paused:
					get_tree().paused = true
					add_child(pause_menu.instantiate())
				elif get_tree().paused && get_node("settings_menu") != null:
					get_node("settings_menu").queue_free()
				elif get_tree().paused && get_node("pause_menu") != null:
					get_node("pause_menu").queue_free()
					get_tree().paused = false
			elif event.is_action_pressed("power_up_inventory") && inventory_open:
				get_node("power_up_inventory").queue_free()
				inventory_open = false
				get_tree().paused = false
			elif event.is_action_pressed("power_up_inventory") && !get_tree().paused:
				var inventory = setup_inventory()
				add_child(inventory)
				inventory_open = true

				get_tree().paused = true

func setup_inventory():
	var inventory = power_up_inventory.instantiate()
	for power in player.power_ups:
		var control_parent : Control = power_up_control_node.instantiate()
		inventory.get_node("canvas/panel/inventory_grid").add_child(control_parent)
		control_parent.title = power.title
		control_parent.description = power.description
		control_parent.level = power.level
		control_parent.icon = power.get_node("icon").texture
		for tag in power.get_groups():
			control_parent.tags.append(tag)
	return inventory

func _on_player_death():
	session_timer.stop()
	get_tree().paused = true
	get_tree().current_scene.get_node("ui_canvas").queue_free()
	var inventory = setup_inventory()
	
	var stats_screen = death_screen.instantiate()
	stats_screen.get_node("control").get_node("enemies_killed").text = "Kills: " + str(enemies_killed)
	var time_alive : String = ""
	while seconds_alive > 0:
		if seconds_alive >= 3600:
			time_alive += str(int(seconds_alive / 3600)) + "h "
			seconds_alive -= int((seconds_alive / 3600) * 3600)
		elif seconds_alive >= 60:
			time_alive += str(int(seconds_alive / 60)) + "m "
			seconds_alive -= int((seconds_alive / 60) * 60)
		else:
			time_alive += str(seconds_alive) + "s"
			seconds_alive -= seconds_alive
	stats_screen.get_node("control").get_node("time_alive").text = "Time Alive: " + str(time_alive)
	
	add_child(inventory)
	add_child(stats_screen)

func _on_session_timer_timeout():
	seconds_alive += 1

func _on_spawn_timer_timeout():
	spawn_wave(2, 4)
	spawn_timer.wait_time *= 0.99
