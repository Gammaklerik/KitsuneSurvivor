extends CharacterBody2D

var speed : float = 360

var player : CharacterBody2D
var player_pos : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().current_scene.get_node("Player_Body")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if player != null:
		player_pos = to_local(player.global_position)
		velocity = velocity.move_toward(player_pos, speed)
		#velocity.x = move_toward(velocity.x, 0, speed)
		#velocity.y = move_toward(velocity.y, 0, speed)
		move_and_slide()
