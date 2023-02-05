extends Node2D

export var juicyness: float = 0.0
onready var juice = $glass_juice

var time = 0

func map(value, min1, max1, min2, max2) -> float:
	return min2 + (value - min1) * (max2 - min2) / (max1 - min1)

func _ready():
	pass # Replace with function body.

func _process(delta):
	time += delta
	juicyness = clamp(juicyness, 0.0, 1.0)
	juice.position.y = lerp(809, 392, juicyness)
	if Input.is_action_just_pressed("player1_up"):
		fill(0.5, 1)

func fill(amountToAdd: float, duration: float):
	var beginJuice = juicyness
	var targetJuice = beginJuice + amountToAdd
	var beginTime = time
	var endTime = time + duration
	var stepTime = 0.02
	
	while time < endTime:
		var durationLeft = endTime - time
		juicyness = map(time, beginTime, endTime, beginJuice, targetJuice)
		yield(get_tree(), "idle_frame")
	
	juicyness = targetJuice
