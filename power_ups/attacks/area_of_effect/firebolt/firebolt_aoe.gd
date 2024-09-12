extends Area2D

var damage : float

var area_multiplier : float :
	set(value):
		area_multiplier = value
		$area.scale *= area_multiplier
		$aoe_sprite.scale *= area_multiplier
@export var effect_timer : Timer
@onready var dot_handler : PackedScene = preload("res://game/damage_over_time.tscn")
var dot_duration : float
var dot_rate : float
var dot_damage : float

func _on_body_entered(body):
	if body.get_groups().has("enemy"):
		body.take_damage(damage)

func _on_effect_timer_timeout():
	queue_free()

func _on_damage_rate_timeout():
	for body in get_overlapping_bodies():
		if body.is_in_group("enemy"):
			body.take_damage(damage)

func _on_body_exited(body):
	if body.is_in_group("enemy"):
		var burn : Node = dot_handler.instantiate()
		burn.get_node("duration").wait_time = dot_duration
		burn.get_node("rate").wait_time = dot_rate
		burn.damage = dot_damage
		body.add_child(burn)
