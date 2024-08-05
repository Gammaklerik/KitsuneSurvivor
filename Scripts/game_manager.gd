extends Node

@export var melee_01 : PackedScene
@export var projectile_01 : PackedScene
var enemies : Array[PackedScene]

var wave_list : Array[RigidBody2D]

@export var camera : Camera2D
@export var player : CharacterBody2D

var power_up_canvas : PackedScene = preload("res://Scenes/power_up_canvas.tscn")
var pause_menu : PackedScene = preload("res://Scenes/pause_menu.tscn")
var power_up_inventory : PackedScene = preload("res://Scenes/power_up_inventory.tscn")
var power_up_control_node : PackedScene = preload("res://Scenes/inventory_control.tscn")
var inventory_open : bool = false

func _ready():
	enemies = [melee_01, projectile_01]
	spawn_wave(6, 10)

func spawn_wave(min: int, max: int):
	var wave_size : int = randi_range(min, max)
	for enemy in wave_size:
		var enemy_instance = enemies.pick_random().instantiate()
		add_child(enemy_instance)
		enemy_instance.position = get_spawn_position()
		wave_list.append(enemy_instance)

func get_spawn_position():
	var spawn_position : Vector2
	
	# Gets the x value of the left hand side of the screen
	var camera_x_min : float = camera.get_screen_center_position().x - (camera.get_viewport().size.x / 2)
	# Gets the x value of the right hand side of the screen
	var camera_x_max : float = camera.get_viewport().size.x
	# Gets the y value of the top of the screen
	var camera_y_min : float = camera.get_screen_center_position().y - (camera.get_viewport().size.y / 2)
	# Gets the y value of the bottom of the screen
	var camera_y_max : float = camera.get_screen_center_position().y + (camera.get_viewport().size.y / 2)
	
	# randi is essecially a coin flip,
	# 50/50 chance of the enemy spawning on the top or bottom of the screen 
	# or on the left or right hand side
	if randi_range(1, 2) == 1:
		spawn_position.x = randf_range(camera_x_min, camera_x_max)
		if randi_range(1, 2) == 1:
			spawn_position.y = camera_y_min - 20
		else:
			spawn_position.y = camera_y_max + 20
	else:
		spawn_position.y = randf_range(camera_y_min, camera_y_max)
		if randi_range(1, 2) == 1:
			spawn_position.x = camera_x_min - 20
		else:
			spawn_position.x = camera_x_max + 20
	
	return spawn_position

func _on_enemy_death(enemy):
	wave_list.erase(enemy)
	if wave_list.size() == 0:
		spawn_wave(15, 20)

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
				elif get_tree().paused:
					if get_node("pause_menu") != null:
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
