extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

enum ANIMSTATE { idle,punch,jump }
export(ANIMSTATE) var anim_state = ANIMSTATE.idle

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	#$AnimationTree.set("parameters/playback")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
