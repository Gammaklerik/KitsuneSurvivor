extends Node2D

var title = "Serrated Blades"
var description = "Serrate your blades, giving them bleed."
var level = 1

var dot_handler : PackedScene = preload("res://game/damage_over_time.tscn")
var bleed_chance : float = 0.07
var percent_atk_dmg : float = 0.2

var dot_duration : float = 2.5
var dot_rate : float = 0.5

func activate(player: CharacterBody2D):
	if player != null:
		for power in player.power_ups:
			if power.is_in_group("attack") && power.is_in_group("physical"):
				power.dot_handler = dot_handler
				power.bleed_chance = bleed_chance
				power.dot_damage = (power.atk_damage * percent_atk_dmg) / (dot_duration / dot_rate)
				power.dot_duration = dot_duration
				power.dot_rate = dot_rate

func level_up():
	level += 1
	if level == 2:
		bleed_chance = 0.14
		percent_atk_dmg = 0.22
	elif level == 3:
		bleed_chance = 0.3
		percent_atk_dmg = 0.24

