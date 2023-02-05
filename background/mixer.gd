extends Node2D


var initial_collision_mask = 0
var initial_collision_layer = 0
onready var collider = $Sprite/MixerCollider
onready var sprite = $Sprite
onready var animation = $AnimationPlayer

func _ready():
	initial_collision_mask = collider.collision_mask
	initial_collision_layer = collider.collision_layer
	collider.collision_mask = 0
	collider.collision_layer = 0

func turnOn(var duration: float):
	
	# return early if the mixer is still on
	if animation.is_playing():
		return
	
	animation.play("Shake")
	yield(get_tree().create_timer(1.8), "timeout")
	collider.collision_mask = initial_collision_mask
	collider.collision_layer = initial_collision_layer
	sprite.playing = true
	yield(get_tree().create_timer(duration), "timeout")
	collider.collision_mask = 0
	collider.collision_layer = 0
	sprite.playing = false
	animation.stop()
	
