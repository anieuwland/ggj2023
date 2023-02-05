extends Node


export(NodePath) var mixer
export var enabled: bool = true

onready var mixerNode = get_node(mixer)
var stop = false

func _ready():
	controlForever()

func controlForever():
	while not stop:
		yield(get_tree().create_timer(15), "timeout")
		if enabled && not stop:
			mixerNode.turnOn(1.5, 3)

func _exit_tree():
	stop = true
