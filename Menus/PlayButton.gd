extends Button


func onPressed():
	var game_node = get_node("/root/Game")
	game_node.get_node('kitcken/menu_select').play()
	game_node.change_scene("res://Menus/CharacterSelection.tscn", true)
