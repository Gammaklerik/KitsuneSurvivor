extends Area2D

var branch_damage : float

var hit_enemies : Array[RigidBody2D]
var branching_enemy_pos : Vector2
@onready var branch_sprite : PackedScene = preload("res://power_ups/attacks/beam/lightning_bolt/branch.tscn")

func _on_body_entered(body):
	if body.is_in_group("enemy") && !hit_enemies.has(body):
		branch()

func branch():
	var closest_enemy : RigidBody2D
	for body in get_overlapping_bodies():
		if body.is_in_group("enemy"):
			if closest_enemy == null:
				closest_enemy = body
			else:
				if branching_enemy_pos.distance_to(body.position) < branching_enemy_pos.distance_to(closest_enemy.position):
					closest_enemy = body
	if closest_enemy != null:
		var branch_strike : Node2D = branch_sprite.instantiate()
		branch_strike.position = to_local(branching_enemy_pos)
		branch_strike.rotation = self.global_position.angle_to_point(closest_enemy.global_position)
		branch_strike.target = closest_enemy.global_position
		add_child(branch_strike)
		closest_enemy.take_damage(branch_damage)
