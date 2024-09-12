extends Sprite2D

@onready var player : CharacterBody2D = get_tree().current_scene.get_node("player")

var value : int = 20
var in_range : bool = false

func _physics_process(delta):
	if in_range && player != null:
		self.global_position = self.global_position.move_toward(player.global_position, 1.2)

func _on_range_area_body_entered(body):
	if body.is_in_group("player"):
		in_range = true

func _on_pickup_range_body_entered(body):
	if body.is_in_group("player"):
		body.get_node("stats").current_health += value
		queue_free()
