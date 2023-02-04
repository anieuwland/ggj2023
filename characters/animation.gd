extends AnimationTree

onready var animation_state: AnimationNodeStateMachinePlayback = self["parameters/playback"]

var current_anim = null
signal animation_changed(old_anim, new_anim)

func travel(anim_name: String) -> void:
	animation_state.travel(anim_name)

func get_current_node() -> String:
	return animation_state.get_current_node()
	
func _process(delta):
	var anim_name: String = get_current_node()
	if current_anim != anim_name:
		emit_signal("animation_changed", current_anim, anim_name)
		current_anim = anim_name
