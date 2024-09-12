extends Node2D

var target : Vector2

func _process(delta):
	position = position.move_toward(to_local(target), 50)
