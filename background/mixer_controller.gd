extends Node


export(NodePath) var mixer
export var enabled: bool = true

onready var mixerNode = get_node(mixer)

func _ready():
	controlForever()

func controlForever():
	while true:
		yield(get_tree().create_timer(15), "timeout")
		if enabled:
			mixerNode.turnOn(1.5, 3)
