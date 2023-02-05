extends CPUParticles2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("player1_up"):
		runFor(1)

func runFor(duration: float):
	emitting = true
	yield(get_tree().create_timer(duration), "timeout")
	emitting = false
