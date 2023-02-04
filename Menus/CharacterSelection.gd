extends CenterContainer


var player1_character = 0
var player2_character = 3
var characters = []
var player1: Node = null
var player2: Node = null

var char_select_sound = preload("res://resources/audio/charselect.wav")


func update_player1():
		var n = find_node("Player1")
		while n.get_child_count() > 0:
			n.remove_child(n.get_child(0))
		player1 = characters[player1_character].duplicate()
		n.add_child(player1)

func update_player2():
		var n = find_node("Player2")
		while n.get_child_count() > 0:
			n.remove_child(n.get_child(0))
		player2 = characters[player2_character].duplicate()
		n.add_child(player2)

# Called when the node enters the scene tree for the first time.
func _ready():
	characters.append(find_node("Character1").get_child(0))
	characters.append(find_node("Character2").get_child(0))
	characters.append(find_node("Character3").get_child(0))
	characters.append(find_node("Character4").get_child(0))
	characters.append(find_node("Character4").get_child(0))
	update_player1()
	update_player2()
	$AudioStreamPlayer2D.stream = char_select_sound
	$AudioStreamPlayer2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("player1_left"):
		var initial_value = player1_character
		player1_character -= 1
		if player1_character == player2_character:
			player1_character -= 1
		if player1_character < 0:
			player1_character = initial_value
		else:
			update_player1()

	if Input.is_action_just_pressed("player1_right"):
		var initial_value = player1_character
		player1_character += 1
		if player1_character == player2_character:
			player1_character += 1
		if player1_character > 3:
			player1_character = initial_value
		else:
			update_player1()
	
	if Input.is_action_just_pressed("player2_left"):
		var initial_value = player2_character
		player2_character -= 1
		if player1_character == player2_character:
			player2_character -= 1
		if player2_character < 0:
			player2_character = initial_value
		else:
			update_player2()

	if Input.is_action_just_pressed("player2_right"):
		var initial_value = player2_character
		player2_character += 1
		if player1_character == player2_character:
			player2_character += 1
		if player2_character > 3:
			player2_character = initial_value
		else:
			update_player2()

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
	game_node.change_scene_to_node(arena)
