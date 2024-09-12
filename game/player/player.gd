extends CharacterBody2D

var power_ups : Array[Node2D]

var firebolt : PackedScene = preload("res://power_ups/attacks/projectile/firebolt/firebolt.tscn")

@export var ui : CanvasLayer
var power_ups_ui : VBoxContainer
signal new_power
@export var game_manager : Node

signal dead

@onready var sprite_anim : AnimatedSprite2D = $player_sprite

func _ready():
	dead.connect(get_tree().current_scene.get_node("game_manager")._on_player_death)
	
	$stats.connect("health_modified", func(): ui.get_node("ui_control")._on_health_modified($stats.current_health, $stats.max_health))
	$stats.max_health = 10000
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
	
	if velocity != Vector2.ZERO:
		sprite_anim.play("run", 1.0 * $stats.speed_multiplier)
	else:
		sprite_anim.play("idle")
	
	move_and_slide()
	
	if Input.is_action_just_pressed("level_up"):
		$stats.level += 1

func power_up(power: PackedScene):
	var dupe : bool = false
	var power_instance = power.instantiate()
	for p in power_ups:
		if power_instance.title == p.title:
			if (p.level + 1) == 3:
				p.level_up()
				dupe = true
				if p.get_groups().has("attack") && p.atk_cooldown == 0.0:
					p.atk_instance.queue_free()
					p.activate(self)
				elif p.get_groups().has("attack") && p.atk_cooldown > 0.0:
					power_instance.queue_free()
				elif p.get_groups().has("buff"):
					p.activate(self)
				return("max")
			else:
				p.level_up()
				dupe = true
				if p.get_groups().has("attack") && p.atk_cooldown == 0.0:
					p.atk_instance.queue_free()
					p.activate(self)
				elif p.get_groups().has("attack") && p.atk_cooldown > 0.0:
					power_instance.queue_free()
				elif p.get_groups().has("buff"):
					p.activate(self)
	if !dupe:
		if power_instance.get_groups().has("attack") && power_instance.atk_cooldown > 0.0:
			var attack_timer : Timer = Timer.new()
			add_child(attack_timer)
			for group in power_instance.get_groups():
				attack_timer.add_to_group(group)
			attack_timer.wait_time = power_instance.atk_cooldown
			attack_timer.timeout.connect(func(): _on_attack_cooldown(power_instance))
			attack_timer.start()
			
			if power_instance.is_in_group("fire"):
				power_instance.atk_damage_inc = $stats.fire_damage_inc
			if power_instance.is_in_group("lightning"):
				power_instance.atk_damage_inc = $stats.lightning_damage_inc
			if power_instance.is_in_group("physical"):
				power_instance.atk_damage_inc = $stats.physical_damage_inc
				for p in power_ups:
					if p.title == "Serrated Blades":
						p.activate(self)
		elif power_instance.get_groups().has("attack") && power_instance.atk_cooldown == 0.0:
			if power_instance.is_in_group("fire"):
				power_instance.atk_damage_inc = $stats.fire_damage_inc
			if power_instance.is_in_group("lightning"):
				power_instance.atk_damage_inc = $stats.lightning_damage_inc
			if power_instance.is_in_group("physical"):
				power_instance.atk_damage_inc = $stats.physical_damage_inc
			power_instance.activate(self)
		elif power_instance.is_in_group("buff"):
			power_instance.activate(self)
		new_power.emit(power_instance)
		power_ups.append(power_instance)

func _on_attack_cooldown(attack: Node2D):
	attack.activate(self)

func take_damage(dmg: float):
	$stats.current_health -= (dmg * $stats.damage_reduction)
	if $stats.current_health == 0:
		dead.emit()

func _on_enemy_killed(exp: float):
	gain_exp(exp)

func gain_exp(exp: float):
	$stats.experience += exp
	if $stats.exp_max <= $stats.experience:
		$stats.level += 1

func _on_health_regen_timeout():
	$stats.current_health += $stats.health_regen
