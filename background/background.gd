extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var juicyness = 0.0 

onready var juice = $Juice

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if juicyness < 0:
		juicyness = 0
	if juicyness > 1:
		juicyness = 1
	juice.position.y = lerp(37, 0, juicyness)
	if Input.is_action_just_pressed("player1_up"):
		drain(1)

func drain(duration: float):
	var durationLeft = duration
	var stepDuration = 0.02
	
	while durationLeft > 0:
		yield(get_tree().create_timer(stepDuration), "timeout")
		var stepsLeft = durationLeft / stepDuration
		var decreaseBy = juicyness / stepsLeft
		juicyness -= decreaseBy
		durationLeft -= stepDuration
		
