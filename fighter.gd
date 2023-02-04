extends KinematicBody2D

const speed = 200.0
const charge_hit_time = 0.2
const hit_time = 0.2

const damage = 10

export(int, "1", "2") var player_id

var action_left: String
var action_right: String
var action_hit: String

enum FightState {IDLE, CHARGE_HIT, HIT}

var fight_state = FightState.IDLE

var fight_state_timer = Timer.new()

signal deal_damage(target, damage)

var fist: Node
var hit_targets: Array = []

onready var animation: AnimationTree = get_node("character").find_node("animation")

func _ready():
	fist = get_node("character").find_node("fist")
	fist.connect("body_entered", self, "on_fist_body_entered")
	fist.monitoring = false
	
	fight_state_timer.one_shot = true
	fight_state_timer.connect("timeout", self, "on_fight_state_timeout")
	add_child(fight_state_timer)
	
	if player_id == 0:
		action_left = "player1_left"
		action_right = "player1_right"
		action_hit = "player1_hit"
	elif player_id == 1:
		action_left = "player2_left"
		action_right = "player2_right"
		action_hit = "player2_hit"
	else:
		assert(false, "Invalid player_id")
		
func _process(delta):
	match fight_state:
		FightState.IDLE:
			if Input.is_action_just_pressed(action_hit):
				animation["parameters/playback"].travel("punch")
				#fight_state = FightState.CHARGE_HIT
				#fight_state_timer.wait_time = charge_hit_time
				#fight_state_timer.start()

func on_fight_state_timeout() -> void:
	match fight_state:
		FightState.CHARGE_HIT:
			hit_targets.clear()
			fist.monitoring = true
			fight_state = FightState.HIT
			fight_state_timer.wait_time = hit_time
			fight_state_timer.start()
		FightState.HIT:
			fist.monitoring = false
			fight_state = FightState.IDLE
			
func on_fist_body_entered(body: Node) -> void:
	if not hit_targets.has(body):
		emit_signal("deal_damage", body, 10)
		hit_targets.append(body)
		

func _physics_process(delta):
	var velocity = 0.0
	
	if Input.is_action_pressed(action_left):
		velocity -= delta * speed
	if Input.is_action_pressed(action_right):
		velocity += delta * speed
		
	move_and_collide(Vector2(velocity, 0))
