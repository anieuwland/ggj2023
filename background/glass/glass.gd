extends Node2D

export var juicyness: float = 0.0
onready var juice = $glass_juice

func _ready():
	pass # Replace with function body.


func _process(delta):
	juicyness = clamp(juicyness, 0.0, 1.0)
	juice.position.y = lerp(809, 392, juicyness)
