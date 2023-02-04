extends Label


# Declare member variables here. Examples:
var timer := Timer.new()
var countdown = 3
var countdown_sound = preload("res://resources/audio/countdown.wav")

signal countdown_finished()

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = 0.05
	timer.one_shot = false
	add_child(timer)
	timer.connect("timeout", self, "_on_timer_timeout")
	$AudioStreamPlayer2D.stream = countdown_sound
	reset()

func reset():
	countdown = 3
	set_count_down_text(str(countdown))
	self.show()
	
func start():
	timer.start()
	$AudioStreamPlayer2D.play()

func _on_timer_timeout():
	countdown -= 1
	var text = str(countdown) if countdown > 0 else "BLEND!"
	set_count_down_text(text)
	if countdown <= -1:
		timer.stop()
		self.hide()
		emit_signal("countdown_finished")

func set_count_down_text(text):
	self.text = text


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
