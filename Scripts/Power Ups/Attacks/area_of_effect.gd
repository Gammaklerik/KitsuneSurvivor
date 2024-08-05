extends Area2D

var damage : float

var area_multiplier : float :
	set(value):
		area_multiplier = value
		$area.scale = Vector2($area.scale.x * area_multiplier, $area.scale.y * area_multiplier)
@export var effect_timer : Timer

func _on_body_entered(body):
	if body.get_groups().has("enemy"):
		body.take_damage(damage)

func _on_effect_timer_timeout():
	queue_free()
