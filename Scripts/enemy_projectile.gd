extends RigidBody2D


var speed : float = 500
var damage : float = 10

var direction : Vector2

func _ready():
	constant_force = Vector2(direction.x * speed, direction.y * speed)

func _on_hitbox_body_entered(body):
	if body.get_groups().has("player"):
		body.take_damage(damage)
		queue_free()

func _on_lifetime_timeout():
	queue_free()
