extends RigidBody2D

var speed : float = 100.0
var damage : float = 3.0

var direction : Vector2

@onready var dot_handler : PackedScene = preload("res://game/damage_over_time.tscn") 
var dot_duration : float = 1.0
var dot_rate : float = 0.35
var dot_damage : float = 1.0

func _ready():
	constant_force = Vector2(direction.x * speed, direction.y * speed)

func _on_gas_area_body_entered(body: Node2D):
	if body.is_in_group("player"):
		body.take_damage(damage)

func _on_gas_area_body_exited(body: Node2D):
	if body.is_in_group("player"):
		var poison : Node = dot_handler.instantiate()
		poison.get_node("duration").wait_time = dot_duration
		poison.get_node("rate").wait_time = dot_rate
		poison.damage = dot_damage
		body.add_child(poison)
		poison.dot_start()

func _on_damage_rate_timeout():
	for body in $gas_area.get_overlapping_bodies():
		if body.is_in_group("player"):
			body.take_damage(damage)

func _on_lifetime_timeout():
	queue_free()
