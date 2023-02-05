extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var juicyness = 0.0 

onready var juice = $Juice

var time = 0

func map(value, min1, max1, min2, max2) -> float:
	return min2 + (value - min1) * (max2 - min2) / (max1 - min1)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	juicyness = clamp(juicyness, 0.0, 1.0)
	juice.position.y = lerp(37, 0, juicyness)

func drain(duration: float):
	var beginJuice = juicyness
	var beginTime = time
	var endTime = time + duration
	var stepTime = 0.02
	
	while time < endTime:
		var durationLeft = endTime - time
		juicyness = map(time, beginTime, endTime, beginJuice, 0)
		yield(get_tree(), "idle_frame")
	
	juicyness = 0
	
func drain_into_glass(duration: float, glass, pour):
	var amount = clamp(1 - glass.juicyness, 0.0, 0.5)
	pour.runFor(duration)
	drain(duration)
	glass.fill(amount, duration)
	$poursound.play()
	
