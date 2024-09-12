extends RigidBody2D

var speed : float
var damage : float

var direction : Vector2

var dot_handler : Node

var aoe_handler : Area2D

func _ready():
	constant_force = Vector2(direction.x * speed, direction.y * speed)

func _on_projectile_hit_area_body_entered(body):
	if !body.is_in_group("player"):
		if body.is_in_group("enemy"):
			body.take_damage(damage)
			if dot_handler != null:
				body.add_child(dot_handler)
				dot_handler.dot_start()
			if aoe_handler != null:
				aoe_handler.position = self.position
				add_sibling(aoe_handler)
		queue_free()

func _on_lifetime_timeout():
	queue_free()
