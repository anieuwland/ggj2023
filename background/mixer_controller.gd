extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(NodePath) var mixer

onready var mixerNode = get_node(mixer)

func _ready():
	pass
	
func _process(delta):
	if Input.is_action_just_pressed("player1_up"):
		mixerNode.turnOn(5)
		
