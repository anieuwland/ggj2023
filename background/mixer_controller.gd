extends Node


export(NodePath) var mixer
export var enabled: bool = true

onready var mixerNode = get_node(mixer)
var stop = false
var movementSpeed = 0.5
var movement = movementSpeed

func _ready():
	controlForever()

func controlForever():
	while not stop:
		yield(get_tree().create_timer(12), "timeout")
		if enabled && not stop:
			mixerNode.turnOn(1.5, 3)

var frameNum = 0
func _process(delta):
	frameNum += 1
	if (frameNum > 8):
		frameNum = 0
	print(enabled, frameNum)
	if (not mixerNode.isOn()):
		if (mixerNode.position.x < -200):
			movement = movementSpeed
		if (mixerNode.position.x > 210):
			movement = -movementSpeed
		mixerNode.position.x += movement

func _exit_tree():
	stop = true
