extends RigidBody2D

var speed : float = 120.0
var max_health : float = 50.0
var current_health : float = max_health
var damage : float = 8.0

signal enemy_killed

var player : CharacterBody2D

var exp_yield : float = 20

var is_spinning : bool = false

@onready var health_bar : HSlider = $ui_elements/health_bar
@onready var damage_number_popup : PackedScene = preload("res://enemies/damage_popup.tscn")
@onready var nav_agent : NavigationAgent2D = $nav_agent
@onready var sprite : AnimatedSprite2D = $sprite
@onready var flame_spouts : Array[Area2D] = [$flame_spout_01, $flame_spout_02, $flame_spout_03]

func _ready():
	player = get_tree().current_scene.get_node("player")
	health_bar.max_value = 100
	health_bar.value = (current_health / max_health) * 100
	
	connect("enemy_killed", func(): get_parent()._on_enemy_death(self))
	connect("enemy_killed", func(): player._on_enemy_killed(exp_yield))

func _physics_process(delta):
	if !is_spinning && $anim_timer.is_stopped():
		nav_agent.target_position = player.global_position
		linear_velocity = global_position.direction_to(nav_agent.get_next_path_position()) * speed
		if linear_velocity.x < 0:
			sprite.flip_h = true
		elif linear_velocity.x > 0:
			sprite.flip_h = false
	else:
		for spout in flame_spouts:
			spout.rotation_degrees += 70 * delta
		sprite.rotation_degrees += 70 * delta

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
	if body.is_in_group("player") && !is_spinning:
		linear_velocity = Vector2.ZERO
		$anim_timer.start()

func _on_anim_timer_timeout():
	is_spinning = true
	for spout in flame_spouts:
		spout.visible = true
		spout.get_node("collider").disabled = false
	$spin_timer.start()

func _on_spin_timer_timeout():
	is_spinning = false
	for spout in flame_spouts:
		spout.visible = false
		spout.get_node("collider").disabled = true
	sprite.rotation_degrees = 0

func _on_flame_spout_01_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(damage)

func _on_flame_spout_02_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(damage)

func _on_flame_spout_03_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(damage)
