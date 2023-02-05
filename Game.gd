extends Control

func change_scene(var scene_path: String):
	while get_child_count() > 0:
		remove_child(get_child(0))
	var new_scene = load(scene_path).instance()
	add_child(new_scene)

func change_scene_to_node(var scene_node: Node):
	while get_child_count() > 0:
		remove_child(get_child(0))
	add_child(scene_node)

func _process(delta):
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen
