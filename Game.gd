extends Control

func change_scene(var scene_path: String, menu_music: bool):
	while get_child_count() > 1:
		remove_child(get_child(1))
	var new_scene = load(scene_path).instance()
	add_child(new_scene)
	set_menu_music(menu_music)

func change_scene_to_node(var scene_node: Node, menu_music: bool):
	while get_child_count() > 1:
		remove_child(get_child(1))
	add_child(scene_node)
	set_menu_music(menu_music)

func set_menu_music(menu_music: bool) -> void:
	if $kitcken/menu_music.playing != menu_music:
		$kitcken/menu_music.playing = menu_music
	if $kitcken/game_music.playing != (not menu_music):
		$kitcken/game_music.playing = not menu_music

func _process(delta):
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen
