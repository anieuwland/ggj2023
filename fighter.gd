extends KinematicBody2D

export(int, "1", "2") var player_id

const speed = 200.0
const punch_damage = 10
const kick_damage = 30
const throw_speed = 400.0

var action_left: String
var action_right: String
var action_hit: String
var action_block: String
var action_grab: String

signal deal_damage(target, damage)
var damage_dealt_sound = preload("res://resources/audio/impact1.wav")
var rng = RandomNumberGenerator.new()

var fist: Node
var hit_targets: Array = []

var init_position
var init_transform 

onready var animation_state = get_node("character").find_node("animation")["parameters/playback"]

func get_state() -> String:
	return animation_state.get_current_node()
	
func reset():
	self.transform = init_transform

func _ready():
	$impact.stream = damage_dealt_sound
	fist = get_node("character").find_node("fist")
	fist.connect("hit", self, "_on_fist_hit")
	fist.monitoring = false
	init_transform = self.transform
	
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
							emit_signal("deal_damage", fighter, punch_damage)
							$impact.pitch_scale = rng.randf_range(0.5, 3.0)
							$impact.play()
							fighter.interrupt()
		"grab":
			if area.name == "hitbox":
				var fighter = area.owner.get_parent()
				if not hit_targets.has(fighter):
					hit_targets.append(fighter)
					
					if not fighter == self:
						emit_signal("deal_damage", fighter, kick_damage)
						fighter.throw()
		_:
			assert(false, "Hit callback called but not in a matching state.")

func _physics_process(delta):
	if get_state() == "stun":
		move_and_collide(Vector2(delta * throw_speed, 0))
	elif get_state() != "stun":
		var velocity = 0.0
		
		if Input.is_action_pressed(action_left):
			velocity -= delta * speed
		if Input.is_action_pressed(action_right):
			velocity += delta * speed
			
		move_and_collide(Vector2(velocity, 0))
	

func throw() -> void:
	animation_state.travel("stun")
	
func interrupt() -> void:
	if get_state() == "grab":
		animation_state.travel("stun")
