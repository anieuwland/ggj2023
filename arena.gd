extends Node2D

onready var healthbar1 = get_node("healthbar1")
onready var healthbar2 = get_node("healthbar2")

func _ready():
	get_node("fighter1").connect("deal_damage", self, "on_fighter1_deal_damage")
	get_node("fighter2").connect("deal_damage", self, "on_fighter2_deal_damage")

func on_fighter1_deal_damage(fighter: Node, damage: float) -> void:
	if fighter.name == "fighter2":
		healthbar2.suffer(damage)

func on_fighter2_deal_damage(fighter: Node, damage: float) -> void:
	if fighter.name == "fighter1":
		healthbar1.suffer(damage)
