extends Node


export(NodePath) var mixer
export var enabled: bool = true

onready var mixerNode = get_node(mixer)
var stop = false
var movementSpeed = 0.5
var movement = movementSpeed

func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	if rng.randf_range(0, 1) < 0.5:
		movement *= -1
	controlForever()

func controlForever():
	while not stop:
		yield(get_tree().create_timer(12), "timeout")
		if enabled && not stop:
			mixerNode.turnOn(1.5, 3)

func _process(delta):
	if (enabled && not mixerNode.isOn()):
		if (mixerNode.position.x < -200):
			movement = movementSpeed
		if (mixerNode.position.x > 210):
			movement = -movementSpeed
		mixerNode.position.x += movement

func _exit_tree():
	stop = true
