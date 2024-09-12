extends Area2D

var damage : float

var direction : Vector2

func _on_body_entered(body: Node2D):
	if body.is_in_group("enemy"):
		body.take_damage(damage)

func _on_sprite_animation_finished():
	queue_free()
