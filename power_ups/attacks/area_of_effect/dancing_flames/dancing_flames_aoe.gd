extends Area2D

var damage : float

var dot_handler : PackedScene = preload("res://game/damage_over_time.tscn")
var dot_damage : float
var dot_duration : float
var dot_rate : float

func _physics_process(delta):
	self.rotation_degrees += 100 * delta

func _on_body_entered(body):
	if body.get_groups().has("enemy"):
		body.take_damage(damage)
		if body != null:
			var burn : Node = dot_handler.instantiate()
			burn.damage = dot_damage
			burn.get_node("duration").wait_time = dot_duration
			burn.get_node("rate").wait_time = dot_rate
			body.add_child(burn)
			burn.dot_start()
