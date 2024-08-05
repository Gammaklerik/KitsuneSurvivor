extends ShapeCast2D

var damage : float

var direction : Vector2
var range : float

func _ready():
	target_position = Vector2(direction.x * range, direction.y * range)
	$sprite.position = target_position

func _process(delta):
	if collision_result.size() != 0:
		for collision in collision_result:
			if collision.collider != null:
				if collision.collider.is_in_group("enemy"):
					collision.collider.take_damage(damage)
			
	queue_free()
