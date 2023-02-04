extends CenterContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var player1_character = 0
var player2_character = 1
var characters = []

# Called when the node enters the scene tree for the first time.
func _ready():
	characters.append(find_node("Character1").get_child(0))
	characters.append(find_node("Character2").get_child(0))
	characters.append(find_node("Character3").get_child(0))
	characters.append(find_node("Character4").get_child(0))
	characters.append(find_node("Character4").get_child(0))
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

	if Input.is_action_just_pressed("player1_right"):
		var initial_value = player1_character
		player1_character += 1
		if player1_character == player2_character:
			player1_character += 1
		if player1_character > 3:
			player1_character = initial_value
	
	if Input.is_action_just_pressed("player2_left"):
		var initial_value = player2_character
		player2_character -= 1
		if player1_character == player2_character:
			player2_character -= 1
		if player2_character < 0:
			player2_character = initial_value

	if Input.is_action_just_pressed("player2_right"):
		var initial_value = player2_character
		player2_character += 1
		if player1_character == player2_character:
			player2_character += 1
		if player2_character > 3:
			player2_character = initial_value
	
	
	
	print(player1_character, player2_character)
	
	pass


func onFightButtonPressed():
	get_tree().change_scene("res://arena.tscn")

	pass # Replace with function body.
