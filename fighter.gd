extends KinematicBody2D

const speed = 200.0

export(int, "1", "2") var player_id

var action_left: String
var action_right: String

func _ready():
	if player_id == 0:
		action_left = "player1_left"
		action_right = "player1_right"
	elif player_id == 1:
		action_left = "player2_left"
		action_right = "player2_right"
	else:
		assert(false, "Invalid player_id")


func _physics_process(delta):
	var velocity = 0.0
	
	if Input.is_action_pressed(action_left):
		velocity -= delta * speed
	if Input.is_action_pressed(action_right):
		velocity += delta * speed
		
	move_and_collide(Vector2(velocity, 0))
