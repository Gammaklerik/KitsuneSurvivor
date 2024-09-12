extends RigidBody2D

var speed : float = 120
var max_health : float = 50
var current_health : float = max_health
var damage : float = 3.0

var distance : float = 250.0
var on_cooldown : bool = false

signal enemy_killed

var player : CharacterBody2D

var exp_yield : float = 20

@onready var health_bar : HSlider = $ui_elements/health_bar
@export var damage_number_popup : PackedScene
@onready var nav_agent : NavigationAgent2D = $nav_agent
@onready var sprite : Sprite2D = $sprite
@onready var animation_timer : Timer = $animation_timer
@onready var run_timer : Timer = $run_timer
@onready var dmg_tick : Timer = $proximity_area/dmg_tick
@onready var prox_area : Area2D = $proximity_area
@onready var vfx : Sprite2D = $proximity_area/fire

var is_running : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().current_scene.get_node("player")
	health_bar.max_value = 100
	health_bar.value = (current_health / max_health) * 100
	
	connect("enemy_killed", func(): get_parent()._on_enemy_death(self))
	connect("enemy_killed", func(): player._on_enemy_killed(exp_yield))

func _physics_process(delta):
	if !animation_timer.time_left > 0:
		nav_agent.target_position = player.global_position
		linear_velocity = global_position.direction_to(nav_agent.get_next_path_position()) * speed
	else:
		linear_velocity = Vector2(0, 0)
	if is_running:
		nav_agent.target_position = player.global_position
		linear_velocity = global_position.direction_to(nav_agent.get_next_path_position()) * (speed * 1.5)
		if prox_area.get_overlapping_bodies().has(player):
			if dmg_tick.is_stopped():
				player.take_damage(damage)
				dmg_tick.start()
		else:
			if !dmg_tick.is_stopped():
				dmg_tick.stop()
		
	if linear_velocity.x < 0:
		sprite.flip_h = true
		prox_area.scale.x = 1
	elif linear_velocity.x > 0:
		sprite.flip_h = false
		prox_area.scale.x = -1

func take_damage(dmg):
	current_health -= dmg
	health_bar.value = (current_health / max_health) * 100
	var damage_label = damage_number_popup.instantiate()
	damage_label.get_node("damage_label").text = str(int(dmg))
	damage_label.position = self.position
	add_sibling(damage_label)
	if current_health <= 0:
		enemy_killed.emit()

func _on_enemy_killed():
	queue_free()

func _on_proximity_area_body_entered(body):
	if body.is_in_group("player"):
		if !is_running:
			animation_timer.start()

func _on_animation_timer_timeout():
	is_running = true
	vfx.visible = true
	run_timer.start()

func _on_run_timer_timeout():
	is_running = false
	vfx.visible = false

func _on_dmg_tick_timeout():
	player.take_damage(damage)
