extends Node2D

 
onready var healthbar1 = get_node("healthbar1")
onready var healthbar2 = get_node("healthbar2")

func _ready():
	var fighter1 = get_node("fighter1")
	var fighter2 = get_node("fighter2")
	var countdown = get_node("countdown")
	
	fighter1.connect("deal_damage", self, "on_fighter1_deal_damage")
	fighter2.connect("deal_damage", self, "on_fighter2_deal_damage")
	countdown.connect("countdown_finished", self, "on_countdown_finished")
	
	_enable_object(fighter1, false)
	_enable_object(fighter2, false)

func on_fighter1_deal_damage(fighter: Node, damage: float) -> void:
	if fighter.name == "fighter2":
		healthbar2.suffer(damage)

func on_fighter2_deal_damage(fighter: Node, damage: float) -> void:
	if fighter.name == "fighter1":
		healthbar1.suffer(damage)

func _enable_object(object, enabledness: bool):
	object.set_process(enabledness)
	object.set_physics_process(enabledness)
	object.set_process_input(enabledness)

func on_countdown_finished():
	var fighter1 = get_node("fighter1")
	var fighter2 = get_node("fighter2")
	_enable_object(fighter1, true)
	_enable_object(fighter2, true)
