extends RigidBody2D

var speed # = 120.0
var max_health # = 50.0
var current_health # = max_health
var damage # = 8.0

signal enemy_killed

var player #: CharacterBody2D
var exp_yield # = 20

@onready var health_bar : HSlider = $ui_elements/health_bar
@onready var damage_number_popup : PackedScene = preload("res://enemies/damage_popup.tscn")
@onready var nav_agent : NavigationAgent2D = $nav_agent
@onready var sprite : AnimatedSprite2D = $sprite

@export var projectile : PackedScene
@onready var attack_cooldown : Timer = $attack_cooldown
var distance : float = 250.0
var on_cooldown : bool = false

func _ready():
	player = get_tree().current_scene.get_node("player")
	health_bar.max_value = 100
	health_bar.value = (current_health / max_health) * 100
	
	connect("enemy_killed", func(): get_parent()._on_enemy_death(self))
	connect("enemy_killed", func(): player._on_enemy_killed(exp_yield))

func _physics_process(delta):
	if nav_agent.target_position.distance_to(self.position) <= distance && !on_cooldown:
		fire_projectile()
	nav_agent.target_position = player.global_position
	linear_velocity = global_position.direction_to(nav_agent.get_next_path_position()) * speed
	if linear_velocity.x < 0:
		sprite.flip_h = true
	elif linear_velocity.x > 0:
		sprite.flip_h = false

func fire_projectile():
	var projectile_instance = projectile.instantiate()
	projectile_instance.direction = self.global_position.direction_to(player.global_position)
	projectile_instance.rotation_degrees = rad_to_deg(self.global_position.angle_to_point(player.global_position)) + 90
	projectile_instance.position = self.position
	add_sibling(projectile_instance)
	attack_cooldown.start()
	on_cooldown = true

func take_damage(dmg):
	current_health -= dmg
	health_bar.value = (current_health / max_health) * 100
	var damage_label = damage_number_popup.instantiate()
	damage_label.get_node("damage_label").text = str(int(dmg))
	damage_label.position = self.position
	add_sibling(damage_label)
	if current_health <= 0:
		enemy_killed.emit()

# Connect 'attack_cooldown.timeout()'
func _on_attack_cooldown_timeout():
	on_cooldown = false

func _on_enemy_killed():
	queue_free()

