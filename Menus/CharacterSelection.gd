extends CenterContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var player1_character = 0
var player2_character = 3
var characters = []


func update_player1():
		var n = find_node("Player1")
		while n.get_child_count() > 0:
			n.remove_child(n.get_child(0))
		n.add_child(characters[player1_character].duplicate())

func update_player2():
		var n = find_node("Player2")
		while n.get_child_count() > 0:
			n.remove_child(n.get_child(0))
		n.add_child(characters[player2_character].duplicate())

# Called when the node enters the scene tree for the first time.
func _ready():
	characters.append(find_node("Character1").get_child(0))
	characters.append(find_node("Character2").get_child(0))
	characters.append(find_node("Character3").get_child(0))
	characters.append(find_node("Character4").get_child(0))
	characters.append(find_node("Character4").get_child(0))
	update_player1()
	update_player2()
	pass # Replace with function body.


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
	
	
	
	#print(player1_character, player2_character)
	
	pass


func onFightButtonPressed():
	get_tree().change_scene("res://arena.tscn")

	pass # Replace with function body.
