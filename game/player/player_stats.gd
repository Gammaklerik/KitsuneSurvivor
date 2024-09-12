extends Node

@onready var player : CharacterBody2D = get_parent()

# Health stats
signal health_modified
var max_health : float :
	set(value):
		max_health = int(value)
		health_modified.emit()

var current_health : float :
	set(value):
		current_health = int(clamp(value, 0, max_health))
		health_modified.emit()

var health_multiplier : float = 1.0 :
	set(value):
		health_multiplier = value
		var health_percent = current_health / max_health
		max_health *= health_multiplier
		current_health = max_health * health_percent

var health_regen : float = 0.0

# Level & EXP related stats
signal level_up
var level : int = 1 :
	set(value):
		level = value
		experience -= exp_max
		exp_max = (level ** 3) + 49
		level_up.emit()

signal exp_changed
var experience : float :
	set(value):
		# Prevents the multiplier from affect the exp from overfilled xp at level up
		if value < 0:
			if experience != 0:
				experience = value
		else:
			experience = value * exp_gain_multiplier
		exp_changed.emit()
var exp_max : float :
	set(value):
		exp_max = value
		exp_changed.emit()
var exp_gain_multiplier : float = 1.0

var speed : float = 200.0
var speed_multiplier : float = 1.0 :
	set(value):
		speed_multiplier = value
		speed *= speed_multiplier

var damage_reduction : float = 1.0

var fire_damage_inc : float = 1.0 : 
	set(value):
		fire_damage_inc = value
		for power in player.power_ups:
			if power.is_in_group("fire") && power.is_in_group("attack"):
				power.atk_damage_inc = fire_damage_inc

var lightning_damage_inc : float = 1.0 : 
	set(value):
		lightning_damage_inc = value
		for power in player.power_ups:
			if power.is_in_group("lightning") && power.is_in_group("attack"):
				power.atk_damage_inc = lightning_damage_inc

var physical_damage_inc : float = 1.0 :
	set(value):
		physical_damage_inc = value
		for power in player.power_ups:
			if power.is_in_group("physical") && power.is_in_group("attack"):
				power.atk_damage_inc = physical_damage_inc
