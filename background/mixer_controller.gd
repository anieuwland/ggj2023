extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(NodePath) var mixer

onready var mixerNode = get_node(mixer)

func _ready():
	controlForever()

func controlForever():
	while true:
		yield(get_tree().create_timer(15), "timeout")
		mixerNode.turnOn(1.5, 3)
