extends Node2D

@export var title : String = "Lightning Bolt"
@export var description : String = "Fire out a bolt of lightning dealing " + str(damage) + " lightning damage."
@export var level : int = 1

@export var attack : PackedScene
@export var damage : float = 30.0
var damage_inc : float = 1.0 :
	set(value):
		damage_inc = value
		damage *= damage_inc
@export var cooldown : float = 2.0

@export var range : float = 300.0

func activate(player: CharacterBody2D):
	var beam : ShapeCast2D = attack.instantiate()
	beam.damage = damage
	beam.range = range
	beam.direction = player.global_position.direction_to(player.get_global_mouse_position())
	beam.position = player.position
	player.add_sibling(beam)
