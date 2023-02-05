extends Node2D


var initial_collision_mask = 0
var initial_collision_layer = 0
onready var collider = $Sprite/MixerCollider
onready var sprite = $Sprite
onready var animation = $AnimationPlayer
signal deal_damage(target, damage)
var watt_equals_PAIN = 1

func isOn() -> bool:
	return animation.is_playing()

func _ready():
	initial_collision_mask = collider.collision_mask
	initial_collision_layer = collider.collision_layer
	collider.collision_mask = 0
	collider.collision_layer = 0

func _process(_delta) -> void:
	for area in collider.get_overlapping_areas():
		_unfortunate_soul(area)

func turnOn(var warmup: float, var duration: float):
	
	# return early if the mixer is still on
	if animation.is_playing():
		return
	
	animation.play("Shake")
	$shakesound.play()
	yield(get_tree().create_timer(warmup), "timeout")
	$shakesound.stop()
	$blendsound.play()
	collider.collision_mask = initial_collision_mask
	collider.collision_layer = initial_collision_layer
	sprite.playing = true
	yield(get_tree().create_timer(duration), "timeout")
	$blendsound.stop()
	collider.collision_mask = 0
	collider.collision_layer = 0
	sprite.playing = false
	animation.stop()
	
func _unfortunate_soul(area: Area2D) -> void:
	if area.name == "hitbox":
		var fighter = area.owner.get_parent()
		fighter.on_suffer(watt_equals_PAIN)
		emit_signal("deal_damage", fighter, watt_equals_PAIN)
