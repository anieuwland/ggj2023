extends KinematicBody2D

export(int, "1", "2") var player_id

const speed = 200.0
const damage = 10

var action_left: String
var action_right: String
var action_hit: String
var action_block: String
var action_grab: String

signal deal_damage(target, damage)

var fist: Node
var hit_targets: Array = []

onready var animation_state = get_node("character").find_node("animation")["parameters/playback"]

func get_state() -> String:
	return animation_state.get_current_node()

func _ready():
	fist = get_node("character").find_node("fist")
	fist.connect("hit", self, "_on_fist_hit")
	fist.monitoring = false
	
	if player_id == 0:
		action_left = "player1_left"
		action_right = "player1_right"
		action_hit = "player1_hit"
		action_block = "player1_block"
		action_grab = "player1_grab"
	elif player_id == 1:
		action_left = "player2_left"
		action_right = "player2_right"
		action_hit = "player2_hit"
		action_block = "player2_block"
		action_grab = "player2_grab"
	else:
		assert(false, "Invalid player_id")
		
func _process(_delta):
	match get_state():
		"idle":
			if Input.is_action_just_pressed(action_hit):
				hit_targets.clear()
				animation_state.travel("punch")
			elif Input.is_action_just_pressed(action_block):
				animation_state.travel("block")
			elif Input.is_action_just_pressed(action_grab):
				hit_targets.clear()
				animation_state.travel("grab")
				
func _on_fist_hit(area: Area2D) -> void:
	match get_state():
		"punch":
			if area.name == "hitbox":
				var fighter = area.owner.get_parent()
				if not hit_targets.has(fighter):
					hit_targets.append(fighter)
					
					if not fighter == self:
						if fighter.get_state() != "block":
							emit_signal("deal_damage", fighter, 10)
						else:
							print("block!")
		"grab":
			if area.name == "hitbox":
				var fighter = area.owner.get_parent()
				if not hit_targets.has(fighter):
					hit_targets.append(fighter)
					print("grab!")
					#emit_signal("deal_damage", fighter, 10)
		_:
			assert(false, "Hit callback called but not in a matching state.")

func _physics_process(delta):
	var velocity = 0.0
	
	if Input.is_action_pressed(action_left):
		velocity -= delta * speed
	if Input.is_action_pressed(action_right):
		velocity += delta * speed
		
	move_and_collide(Vector2(velocity, 0))
