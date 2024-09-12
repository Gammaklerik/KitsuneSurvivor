extends RigidBody2D

var speed : float = 30.0
var max_health : float = 100.0
var current_health : float = max_health
var damage : float = 55.0

signal enemy_killed

@onready var player : CharacterBody2D = get_tree().current_scene.get_node("player")

var exp_yield : float = 50

@onready var health_bar : HSlider = $ui_elements/health_bar
@onready var damage_number_popup : PackedScene = preload("res://enemies/damage_popup.tscn")
@onready var nav_agent : NavigationAgent2D = $nav_agent
@onready var sprite : Sprite2D = $sprite
@onready var anim_timer : Timer = $anim_timer
@onready var movement_anim_timer : Timer = $movement_anim_timer

func _ready():
	health_bar.max_value = 100
	health_bar.value = (current_health / max_health) * 100
	
	connect("enemy_killed", func(): get_parent()._on_enemy_death(self))
	connect("enemy_killed", func(): player._on_enemy_killed(exp_yield))

func _physics_process(delta):
	nav_agent.target_position = player.global_position
	if anim_timer.is_stopped() && !movement_anim_timer.is_stopped():
		linear_velocity = global_position.direction_to(nav_agent.get_next_path_position()) * speed
		if linear_velocity.x < 0:
			sprite.flip_h = false
		elif linear_velocity.x > 0:
			sprite.flip_h = true
	else:
		linear_velocity = Vector2.ZERO

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

func _on_anim_timer_timeout():
	$attack_area.visible = true
	$attack_timer.start()
	movement_anim_timer.start()

func _on_movement_anim_timer_timeout():
	anim_timer.start()

func _on_attack_area_body_entered(body):
	if body.is_in_group("player") && $attack_area.visible:
		body.take_damage(damage)

func _on_attack_timer_timeout():
	$attack_area.visible = false
