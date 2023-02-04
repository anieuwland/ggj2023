extends Node2D

onready var fighter1 = get_node("fighter1")
onready var fighter2 = get_node("fighter2")
onready var healthbar1 = get_node("healthbar1")
onready var healthbar2 = get_node("healthbar2")
onready var countdown = get_node("countdown")

var wins_p1: int = 0
var wins_p2: int = 0

func _ready():
	fighter1.connect("deal_damage", self, "on_fighter1_deal_damage")
	fighter2.connect("deal_damage", self, "on_fighter2_deal_damage")
	countdown.connect("countdown_finished", self, "on_countdown_finished")
	
	healthbar1.connect("health_depleted", self, "on_depleted_health1")
	healthbar2.connect("health_depleted", self, "on_depleted_health2")
	
	reset()
	countdown.start()

func _process(delta):
	pass

func reset():
	_enable_object(fighter1, false)
	_enable_object(fighter2, false)

	fighter1.reset()
	fighter2.reset()
	healthbar1.reset()
	healthbar2.reset()
	countdown.reset()

func on_fighter1_deal_damage(fighter: Node, damage: float) -> void:
	if fighter.name == "fighter2":
		healthbar2.suffer(damage)

func on_fighter2_deal_damage(fighter: Node, damage: float) -> void:
	if fighter.name == "fighter1":
		healthbar1.suffer(damage)

func on_depleted_health1():
	wins_p2 += 1
	on_depleted_health()

func on_depleted_health2():
	wins_p1 += 1
	on_depleted_health()

func on_depleted_health():
	reset()
	countdown.start()

func _enable_object(object, enabledness: bool):
	object.set_process(enabledness)
	object.set_physics_process(enabledness)
	object.set_process_input(enabledness)

func on_countdown_finished():
	_enable_object(fighter1, true)
	_enable_object(fighter2, true)
