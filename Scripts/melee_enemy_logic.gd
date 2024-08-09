extends RigidBody2D


var speed : float = 120
var max_health : float = 50
var current_health : float = max_health
var damage : float = 8.0

signal enemy_killed

var player : CharacterBody2D

var exp_points : float = 20

@export var health_bar : HSlider
@export var damage_number_popup : PackedScene
@onready var nav_agent : NavigationAgent2D = $nav_agent
@onready var sprite : AnimatedSprite2D = $sprite
@onready var vfx_anim : AnimatedSprite2D = $vfx

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().current_scene.get_node("player")
	health_bar.max_value = max_health
	health_bar.value = current_health
	
	connect("enemy_killed", func(): get_parent()._on_enemy_death(self))
	connect("enemy_killed", func(): player._on_enemy_killed(exp_points))

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
	current_health -= dmg
	health_bar.value = current_health
	var damage_label = damage_number_popup.instantiate()
	damage_label.get_node("damage_label").text = str(int(dmg))
	damage_label.position = self.position
	add_sibling(damage_label)
	if current_health <= 0:
		enemy_killed.emit()

func _on_enemy_killed():
	queue_free()

func _on_vfx_frame_changed():
	if vfx_anim.frame == 2:
		$attack_area/attack_col.disabled = false

func _on_attack_range_body_entered(body):
	vfx_anim.visible = true
	vfx_anim.play("attack")

func _on_vfx_animation_finished():
	vfx_anim.visible = false
	vfx_anim.stop()
	$attack_area/attack_col.disabled = true
