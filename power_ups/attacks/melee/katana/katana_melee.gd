extends Area2D

var damage : float

var level : int

var dot_handler : Node
var bleed_chance : float

func _on_body_entered(body):
	if body.get_groups().has("enemy"):
		body.take_damage(damage)
		if dot_handler != null && randf_range(0.0, 1.0) <= bleed_chance:
			body.add_child(dot_handler)
			dot_handler.dot_start()

func _on_anim_timer_timeout():
	queue_free()
