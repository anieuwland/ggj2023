extends CenterContainer


var player1_character = 0
var player2_character = 3
var characters = []
var selectors = []
var player1: Node = null
var player2: Node = null

var selector_blue = preload("res://Menus/assets/selector_blue.jpg")
var selector_red = preload("res://Menus/assets/selector_red.jpg")
var selector_none = preload("res://Menus/assets/selector_none.jpg")

var char_select_sound = preload("res://resources/audio/charselect.wav")


func update_player1(var old_character: int):
	selectors[old_character].texture = selector_none
	var n = find_node("Player1")
	n.remove_child(player1)
	player1 = characters[player1_character].duplicate()
	n.add_child(player1)
	selectors[player1_character].texture = selector_blue

func update_player2(var old_character: int):
	selectors[old_character].texture = selector_none
	var n = find_node("Player2")
	n.remove_child(player2)
	player2 = characters[player2_character].duplicate()
	n.add_child(player2)
	selectors[player2_character].texture = selector_red

# Called when the node enters the scene tree for the first time.
func _ready():
	selectors.append(find_node("Character1").get_child(0))
	selectors.append(find_node("Character2").get_child(0))
	selectors.append(find_node("Character3").get_child(0))
	selectors.append(find_node("Character4").get_child(0))
	characters.append(find_node("Character1").get_child(1))
	characters.append(find_node("Character2").get_child(1))
	characters.append(find_node("Character3").get_child(1))
	characters.append(find_node("Character4").get_child(1))
	update_player1(0)
	update_player2(3)
	$AudioStreamPlayer2D.stream = char_select_sound
	$AudioStreamPlayer2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("player1_left"):
		menu_navigate_sound()
		var initial_value = player1_character
		player1_character -= 1
		if player1_character == player2_character:
			player1_character -= 1
		if player1_character < 0:
			player1_character = initial_value
		else:
			update_player1(initial_value)

	if Input.is_action_just_pressed("player1_right"):
		menu_navigate_sound()
		var initial_value = player1_character
		player1_character += 1
		if player1_character == player2_character:
			player1_character += 1
		if player1_character > 3:
			player1_character = initial_value
		else:
			update_player1(initial_value)
	
	if Input.is_action_just_pressed("player2_left"):
		menu_navigate_sound()
		var initial_value = player2_character
		player2_character -= 1
		if player1_character == player2_character:
			player2_character -= 1
		if player2_character < 0:
			player2_character = initial_value
		else:
			update_player2(initial_value)

	if Input.is_action_just_pressed("player2_right"):
		menu_navigate_sound()
		var initial_value = player2_character
		player2_character += 1
		if player1_character == player2_character:
			player2_character += 1
		if player2_character > 3:
			player2_character = initial_value
		else:
			update_player2(initial_value)
	
	if Input.is_action_just_pressed("ui_accept"):
		onFightButtonPressed()

func onFightButtonPressed():
	var arena = preload("res://arena.tscn").instance()
	var fighter_prototype = preload("res://fighter_prototype.tscn")
	var fighter1 = fighter_prototype.instance()
	var fighter2 = fighter_prototype.instance()
	var character1 = player1.duplicate()
	var character2 = player2.duplicate()
	character1.transform = Transform2D.IDENTITY
	character2.transform = Transform2D.IDENTITY
	character1.name = "character"
	character2.name = "character"
	fighter1.name = "fighter1"
	fighter2.name = "fighter2"
	fighter1.add_child(character1)
	fighter2.add_child(character2)
	fighter1.transform = fighter1.transform.scaled(Vector2(-1, 1))
	fighter1.translate(arena.find_node("player1_spawn").position)
	fighter2.translate(arena.find_node("player2_spawn").position)
	fighter1.player_id = 0
	fighter2.player_id = 1
	
	arena.add_child(fighter1)
	arena.add_child(fighter2)
	var game_node = get_node("/root/Game")
	game_node.get_node('kitcken/menu_select').play()
	game_node.change_scene_to_node(arena, false)

func menu_navigate_sound():
	get_node('/root/Game/kitcken/menu_navigate').play()
