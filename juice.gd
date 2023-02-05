extends CPUParticles2D

func _ready() -> void:
	position += Vector2(100 * rand_range(-1, 1), 100 * rand_range(-1, 1))

func _process(delta):
	if not emitting:
		queue_free()
