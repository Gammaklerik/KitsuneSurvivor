extends Area2D

var damage : float

func _on_body_entered(body):
	if body.get_groups().has("enemy"):
		body.take_damage(damage)
