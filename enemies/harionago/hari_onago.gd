extends RigidBody2D

var speed : float = 120.0
var max_health : float = 50.0
var current_health : float = max_health
var damage : float = 20.0

signal enemy_killed

var player : CharacterBody2D

var exp_yield : float = 20

var player_targetted : bool = false

@onready var health_bar : HSlider = $ui_elements/health_bar
@onready var damage_number_popup : PackedScene = preload("res://enemies/damage_popup.tscn")
@onready var nav_agent : NavigationAgent2D = $nav_agent
@onready var sprite : AnimatedSprite2D = $sprite
@onready var anim_timer : Timer = $anim_timer
@onready var tracking_timer : Timer = $tracking_timer
@onready var hair_spike : PackedScene = preload("res://enemies/harionago/hair_spike.tscn")
var hair : Area2D

func _ready():
	player = get_tree().current_scene.get_node("player")
	health_bar.max_value = 100
	health_bar.value = (current_health / max_health) * 100
	
	connect("enemy_killed", func(): get_parent()._on_enemy_death(self))
	connect("enemy_killed", func(): player._on_enemy_killed(exp_yield))

func _physics_process(delta):
	if !player_targetted:
		nav_agent.target_position = player.global_position
		linear_velocity = global_position.direction_to(nav_agent.get_next_path_position()) * speed
		if linear_velocity.x < 0:
			sprite.flip_h = true
		elif linear_velocity.x > 0:
			sprite.flip_h = false

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

func _on_detection_area_body_entered(body):
	if body.is_in_group("player") && !player_targetted:
		player_targetted = true
		linear_velocity = Vector2.ZERO
		anim_timer.start()
		tracking_timer.start()
		hair = hair_spike.instantiate()
		hair.damage = damage

func _on_anim_timer_timeout():
	add_child(hair)
	anim_timer.start()
	tracking_timer.start()
	hair = hair_spike.instantiate()
	hair.damage = damage

func _on_detection_area_body_exited(body):
	if body.is_in_group("player") && player_targetted:
		player_targetted = false

func _on_tracking_timer_timeout():
	hair.rotation_degrees = rad_to_deg(self.global_position.angle_to_point(player.global_position)) + 90
