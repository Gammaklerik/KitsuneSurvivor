extends RigidBody2D

var speed : float = 120.0
var damage : float = 4.0

signal enemy_killed

var player : CharacterBody2D

var exp_yield : float = 20

@onready var nav_agent : NavigationAgent2D = $nav_agent
@onready var sprite : AnimatedSprite2D = $sprite

func _ready():
	player = get_tree().current_scene.get_node("player")

func _physics_process(delta):
	nav_agent.target_position = player.global_position
	linear_velocity = global_position.direction_to(nav_agent.get_next_path_position()) * speed
	if linear_velocity.x < 0:
		sprite.flip_h = true
	elif linear_velocity.x > 0:
		sprite.flip_h = false

func _on_attack_area_body_entered(body):
	if body.name == "player":
		body.take_damage(damage)

func take_damage(dmg):
	pass
