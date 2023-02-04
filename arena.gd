extends Node2D

# 1 lock objects
# 2 play animation
# 3 unlock objects
 
onready var healthbar1 = get_node("healthbar1")
onready var healthbar2 = get_node("healthbar2")

func _ready():
	var fighter1 = get_node("fighter1")
	var fighter2 = get_node("fighter2")
	
	fighter1.connect("deal_damage", self, "on_fighter1_deal_damage")
	fighter2.connect("deal_damage", self, "on_fighter2_deal_damage")
	
	_enable_object(fighter1, false)
	_enable_object(fighter2, false)
	_show_animation()
	_enable_object(fighter1, true)
	_enable_object(fighter2, true)
	

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

func _show_animation():
	pass
