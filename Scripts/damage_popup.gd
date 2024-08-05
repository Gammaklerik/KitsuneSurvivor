extends Node2D

var final_pos : Vector2

func _ready():
	final_pos = Vector2(position.x + 7, position.y - 7)

func _process(delta):
	position = position.move_toward(final_pos, 0.35)

func _on_lifetime_timeout():
	queue_free()
