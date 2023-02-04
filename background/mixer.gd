extends AnimatedSprite


var initial_collision_mask = 0
var initial_collision_layer = 0
onready var collider = $MixerCollider

func _ready():
	initial_collision_mask = collider.collision_mask
	initial_collision_layer = collider.collision_layer

func _process(delta):
	if (playing):
		collider.collision_mask = initial_collision_mask
		collider.collision_layer = initial_collision_layer
	else:
		collider.collision_mask = 0
		collider.collision_layer = 0
