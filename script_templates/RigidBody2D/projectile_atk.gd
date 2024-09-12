extends RigidBody2D

var speed #: float
var damage #: float

var direction #: Vector2

func _ready():
	constant_force = Vector2(direction.x * speed, direction.y * speed)

# name Area2D "hitobx" and connect the 'body_entered()' signal
func _on_hitbox_body_entered(body):
	if !body.is_in_group("player"):
		if body.is_in_group("enemy"):
			body.take_damage(damage)
		queue_free()
# name Timer "lifetime" and connect 'Timeout()' signal
func _on_lifetime_timeout():
	queue_free()
