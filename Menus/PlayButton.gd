extends Label


func onPressed():
	var game_node = get_node("/root/Game")
	game_node.get_node('kitcken/menu_select').play()
	game_node.change_scene("res://Menus/CharacterSelection.tscn", true)
	
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		onPressed()
