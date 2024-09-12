extends Area2D

var damage : float

func _on_body_entered(body : Node2D):
	if body.is_in_group("player"):
		body.take_damage(damage)

func _on_sprite_animation_finished():
	queue_free()

func _on_anim_timer_timeout():
	queue_free()
