extends KinematicBody2D

export(int, "1", "2") var player_id

const speed = 200.0
const punch_damage = 10
const kick_damage = 30
const throw_speed = 1000.0

var action_left: String
var action_right: String
var action_hit: String
var action_block: String
var action_grab: String
var controller_id: int

signal deal_damage(target, damage)
var damage_dealt_sound = preload("res://resources/audio/impact1.wav")
var rng = RandomNumberGenerator.new()

onready var character: Node2D = get_node("character")
onready var juice_center: Node2D = character.find_node("juice_center")
onready var fist: Node2D = character.find_node("fist")
onready var smileface: Node2D = character.find_node("smileface")
onready var happyface: Node2D = character.find_node("happyface")
onready var cryface: Node2D = character.find_node("cryface")
var hit_targets: Array = []

enum EMOTION {smile, happy, cry}
export(EMOTION) var emotion = EMOTION.smile setget _on_emotion_set

var init_position
var init_transform 

onready var animation_state = get_node("character").find_node("animation")

const juice_scene = preload("res://juice.tscn")
const juice_big_scene = preload("res://juice_big.tscn")

var target: Node = null

func is_blocking() -> bool:
	return get_state() == "block" and fist.action_active

func get_state() -> String:
	return animation_state.get_current_node()
	
func reset():
	self.transform = init_transform

func _ready():
	$impact.stream = damage_dealt_sound
	animation_state.connect("animation_changed", self, "_on_animation_changed")
	self.connect("deal_damage", self, "_on_deal_damage")

	fist.connect("hit", self, "_on_fist_hit")
	fist.connect("kick", self, "_on_kick")
	fist.monitoring = false
	init_transform = self.transform
	
	var gamepads : Array = Input.get_connected_joypads()
	print("gamepads:", gamepads)
	if player_id == 0:
		action_left = "player1_left"
		action_right = "player1_right"
		action_hit = "player1_hit"
		action_block = "player1_block"
		action_grab = "player1_grab"
		controller_id = 0
	elif player_id == 1:
		action_left = "player2_left"
		action_right = "player2_right"
		action_hit = "player2_hit"
		action_block = "player2_block"
		action_grab = "player2_grab"
		controller_id = 1
	else:
		assert(false, "Invalid player_id")
		
func _process(_delta):
	match get_state():
		"dummy":
			animation_state.travel("idle")
		"idle":
			if Input.is_action_just_pressed(action_hit):
				hit_targets.clear()
				animation_state.travel("punch")
				$punch.pitch_scale = rng.randf_range(0.9, 1.1)
				$punch.play()
			elif Input.is_action_just_pressed(action_block):
				animation_state.travel("block")
				$blocktry.pitch_scale = rng.randf_range(1.7, 2.0)
				$blocktry.play()
			elif Input.is_action_just_pressed(action_grab):
				hit_targets.clear()
				animation_state.travel("grab")
				$grab.pitch_scale = rng.randf_range(0.3, 0.5)
				$grab.play()

func _on_fist_hit(area: Area2D) -> void:
	match get_state():
		"punch":
			if area.name == "hitbox":
				var fighter = area.owner.get_parent()
				if not hit_targets.has(fighter):
					hit_targets.append(fighter)
					
					if not fighter == self:
						if fighter.is_blocking():
							fist.reset_action()
							animation_state.travel("stun")
							fighter.blocksuccess()
						else:
							emit_signal("deal_damage", fighter, punch_damage)
							$impact.pitch_scale = rng.randf_range(0.5, 3.0)
							$impact.play()
							fighter.interrupt()
		"grab":
			if area.name == "hitbox":
				var fighter = area.owner.get_parent()
				if not hit_targets.has(fighter):
					hit_targets.append(fighter)
					
					if not fighter == self and target == null:
						target = fighter
						target.getgrabbed()
						animation_state.travel("kick")
						$grabsuccess.pitch_scale = rng.randf_range(0.8, 1.2)
						$grabsuccess.play()
		_:
			print("Hit callback called but not in a matching state.")

func _physics_process(delta):
	if get_state() == "kicked":
		var dir
		if player_id == 0:
			dir = -1.0
		else:
			dir = 1.0
		move_and_collide(Vector2(dir * delta * throw_speed, 0))
	elif get_state() != "stun" and get_state() != "grabbed" and get_state() != "kicked":
		var velocity = 0.0
		
		if Input.is_action_pressed(action_left):
			velocity -= delta * speed
		if Input.is_action_pressed(action_right):
			velocity += delta * speed
			
		move_and_collide(Vector2(velocity, 0))

func _on_kick() -> void:
	emit_signal("deal_damage", target, kick_damage)
	target.throw()
	target = null
	$kick.pitch_scale = rng.randf_range(0.8, 1.2)
	$kick.play()

func throw() -> void:
	animation_state.travel("kicked")
	
func getgrabbed() -> void:
	animation_state.travel("grabbed")
	
func interrupt() -> void:
	if get_state() == "grab":
		fist.reset_action()
		animation_state.travel("stun")
		
func blocksuccess() -> void:
	fist.reset_action()
	animation_state.travel("dummy")
	$block.pitch_scale = rng.randf_range(0.8, 1.2)
	$block.play()
		
func on_suffer(amount: float) -> void: # does not actually deal the damage, just for visuals
	if amount == punch_damage:
		var juice = juice_scene.instance()
		juice_center.add_child(juice)
		juice.emitting = true
	elif amount == kick_damage:
		var juice_big = juice_big_scene.instance()
		juice_center.add_child(juice_big)
		juice_big.emitting = true
	elif amount == 1:
		var juice = juice_scene.instance()
		juice_center.add_child(juice)
		juice.emitting = true
		Input.start_joy_vibration(controller_id, 0, 1, 0.15)
		$suffer.pitch_scale = rng.randf_range(1.5, 2.0)
		$suffer.play()
	else:
		assert("No animation for that amount of damage.")

func _on_emotion_set(emotion) -> void:
	smileface.visible = emotion == EMOTION.smile
	happyface.visible = emotion == EMOTION.happy
	cryface.visible = emotion == EMOTION.cry

func _on_animation_changed(old_anim: String, new_anim: String) -> void:
	match new_anim:
		"grabbed", "stun", "kicked":
			self.emotion = EMOTION.cry
			Input.start_joy_vibration(controller_id, 1, 0, 1)
		"punch", "grab":
			self.emotion = EMOTION.happy
		_:
			self.emotion = EMOTION.smile

func _on_deal_damage(target, damage) -> void:
	Input.start_joy_vibration(controller_id, 0, 1, 0.15)
	Input.start_joy_vibration(target.controller_id, 1, 1, damage/50.0)
