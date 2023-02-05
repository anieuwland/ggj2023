extends CPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func runFor(duration: float):
	emitting = true
	yield(get_tree().create_timer(duration), "timeout")
	emitting = false
