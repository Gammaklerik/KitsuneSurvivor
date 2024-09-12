extends Area2D

var damage : float

@onready var anim_timer : Timer = $anim_timer
@onready var branching_range : PackedScene = preload("res://power_ups/attacks/beam/lightning_bolt/lightning_bolt_branch_range.tscn")
var level : int

func _on_sprite_animation_finished():
	queue_free()

func _on_anim_timer_timeout():
	queue_free()

func _on_body_entered(body):
	var hit_enemies : Array[RigidBody2D]
	if body.is_in_group("enemy") && !hit_enemies.has(body):
		body.take_damage(damage)
		if body != null:
			hit_enemies.append(body)
	if level > 1:
		for enemy in hit_enemies:
			if enemy == null:
				hit_enemies.remove_at(hit_enemies.find(enemy))
		if hit_enemies.size() >= 1:
			var branched_enemies : int = randi_range(1, int((hit_enemies.size()) * (0.25 * (level - 1))))
			for enemy in branched_enemies:
				var rand_enemy_pos : Vector2 = hit_enemies.pick_random().position
				var area_range : Area2D = branching_range.instantiate()
				area_range.position = to_local(rand_enemy_pos)
				area_range.hit_enemies = hit_enemies
				area_range.branching_enemy_pos = rand_enemy_pos
				area_range.branch_damage = damage * (0.30 * (level - 1))
				add_child(area_range)
