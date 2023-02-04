extends Label


# Declare member variables here. Examples:
var timer := Timer.new()
var count_down = 3

signal countdown_finished()

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = 1.0
	timer.one_shot = false
	add_child(timer)
	timer.connect("timeout", self, "_on_timer_timeout")
	set_count_down_text(str(count_down))
	timer.start()

func _on_timer_timeout():
	count_down -= 1
	var text = str(count_down) if count_down > 0 else "BLEND!"
	set_count_down_text(text)
	if count_down <= -1:
		timer.stop()
		self.hide()
		emit_signal("countdown_finished")

func set_count_down_text(text):
	self.text = text


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
