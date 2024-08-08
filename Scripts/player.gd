extends CharacterBody2D

var power_ups : Array[Node2D]

var firebolt : PackedScene = preload("res://Scenes/Power Ups/Attacks/firebolt.tscn")

@export var ui : CanvasLayer
var power_ups_ui : VBoxContainer
signal new_power
@export var game_manager : Node

@onready var sprite_anim : AnimatedSprite2D = $player_sprite

func _ready():
	$stats.connect("health_modified", func(): ui.get_node("ui_control")._on_health_modified($stats.current_health, $stats.max_health))
	$stats.max_health = 100
	$stats.current_health = $stats.max_health
	
	$stats.connect("exp_changed", func(): ui.get_node("ui_control")._on_exp_changed($stats.experience, $stats.exp_max))
	$stats.level = 1
	$stats.connect("level_up", game_manager._on_player_level_up)
	
	connect("new_power", ui.get_node("ui_control")._on_new_power)
	power_up(firebolt)
	
	sprite_anim.play("idle")

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction:
		velocity = direction * $stats.speed
		if direction.x < 0:
			sprite_anim.flip_h = true
		elif direction.x > 0:
			sprite_anim.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, $stats.speed)
		velocity.y = move_toward(velocity.y, 0, $stats.speed)
	
	move_and_slide()

func power_up(power: PackedScene):
	var dupe : bool = false
	var power_instance = power.instantiate()
	for p in power_ups:
		if power_instance.title == p.title:
			p.level += 1
			dupe = true
			power_instance.queue_free()
	if !dupe:
		if power_instance.get_groups().has("attack"):
			var attack_timer : Timer = Timer.new()
			add_child(attack_timer)
			for group in power_instance.get_groups():
				attack_timer.add_to_group(group)
			attack_timer.wait_time = power_instance.cooldown
			attack_timer.timeout.connect(func(): _on_attack_cooldown(power_instance))
			attack_timer.start()
			
			if power_instance.is_in_group("fire"):
				power_instance.damage_inc = $stats.fire_damage_inc
			if power_instance.is_in_group("lightning"):
				power_instance.damage_inc = $stats.lightning_damage_inc
		elif power_instance.is_in_group("stat"):
			pass
		new_power.emit(power_instance)
		power_ups.append(power_instance)

func _on_attack_cooldown(attack: Node2D):
	attack.activate(self)

func take_damage(dmg: float):
	$stats.current_health -= (dmg * $stats.damage_reduction)

func _on_enemy_killed(exp: float):
	gain_exp(exp)

func gain_exp(exp: float):
	$stats.experience += exp
	if $stats.exp_max <= $stats.experience:
		$stats.level += 1
