extends Node

var damage : float
@onready var duration : Timer = $duration
@onready var rate : Timer = $rate

func dot_start():
	duration.start()
	rate.start()

func _on_duration_timeout():
	queue_free()

func _on_rate_timeout():
	if get_parent() != null && (get_parent().is_in_group("enemy") || get_parent().is_in_group("player")):
		get_parent().take_damage(damage)
