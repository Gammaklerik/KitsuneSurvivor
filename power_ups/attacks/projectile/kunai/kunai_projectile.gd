extends RigidBody2D

var speed : float
var damage : float

var direction : Vector2

var dot_handler : Node
var bleed_chance : float

func _ready():
	constant_force = Vector2(direction.x * speed, direction.y * speed)

func _on_hitbox_body_entered(body):
	if body.get_groups().has("enemy"):
		body.take_damage(damage)
		if dot_handler != null && randf_range(0.0, 1.0) <= bleed_chance:
			body.add_child(dot_handler)
			dot_handler.dot_start()
		queue_free()

func _on_lifetime_timeout():
	queue_free()
