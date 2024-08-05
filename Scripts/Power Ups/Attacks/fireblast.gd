extends Node2D

@export var title : String = "Fireblast"
@export var description : String = "Send out a blast of fire centered on yourself dealing " + str(damage) + " fire damage."
@export var level : int = 1

@export var attack : PackedScene
@export var damage : float = 30.0
var damage_inc : float = 1.0 :
	set(value):
		damage_inc = value
		damage *= damage_inc
@export var cooldown : float = 1.5

@export var area_multiplier : float = 1.0
@export var effect_length : float = 0.5

func activate(player: CharacterBody2D):
	var aoe : Area2D = attack.instantiate()
	aoe.damage = damage
	aoe.area_multiplier = area_multiplier
	aoe.effect_timer.wait_time = effect_length
	aoe.position = player.position
	player.add_sibling(aoe)
