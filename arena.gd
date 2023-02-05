extends Node2D

onready var fighter1 = get_node("fighter1")
onready var fighter2 = get_node("fighter2")
onready var healthbar1 = $ui_overlay/healthbar1
onready var healthbar2 = $ui_overlay/healthbar2
onready var countdown = $ui_overlay/countdown
onready var mixer = $Mixer

var juicing_duration = 2.0

func _ready():
	fighter1.connect("deal_damage", self, "on_fighter1_deal_damage")
	fighter2.connect("deal_damage", self, "on_fighter2_deal_damage")
	countdown.connect("countdown_finished", self, "on_countdown_finished")
	
	healthbar1.connect("health_depleted", self, "on_depleted_health1")
	healthbar2.connect("health_depleted", self, "on_depleted_health2")
	$battle_restart_timer.connect("timeout", self, "on_battle_restart_timer")
	
	mixer.connect("deal_damage", self, "_on_mixer_deal_damage")
	
	reset()
	countdown.start()
	$announce_round1.play()

func _process(delta):
	pass

func reset():
	$ui_overlay/battle_msg.hide()
	
	_enable_object(fighter1, false)
	_enable_object(fighter2, false)

	$battle_restart_timer.wait_time = 6
	$background.juicyness = 0
	fighter1.reset()
	fighter2.reset()
	healthbar1.reset()
	healthbar2.reset()
	countdown.reset()

func on_fighter1_deal_damage(fighter: Node, damage: float) -> void:
	if fighter.name == "fighter2":
		fighter2.on_suffer(damage)
		healthbar2.suffer(damage)
	$background.juicyness = calc_juicyness()

func on_fighter2_deal_damage(fighter: Node, damage: float) -> void:
	if fighter.name == "fighter1":
		fighter1.on_suffer(damage)
		healthbar1.suffer(damage)
	$background.juicyness = calc_juicyness()

func _on_mixer_deal_damage(fighter: Node, damage: float) -> void:
	if fighter.name == "fighter1":
		fighter1.on_suffer(damage)
		healthbar1.suffer(damage)
	elif fighter.name == "fighter2":
		fighter2.on_suffer(damage)
		healthbar2.suffer(damage)
	$background.juicyness = calc_juicyness()
	
func calc_juicyness() -> float:
	var dealt1 = healthbar1.health_max - healthbar1.health
	var dealt2 = healthbar2.health_max - healthbar2.health
	var dealt = dealt1 + dealt2
	var dealt_perc = dealt / (healthbar1.health_max + healthbar2.health_max)
	return dealt_perc

var depletions_p1 = 0
func on_depleted_health1():
	depletions_p1 += 1
	$background.drain_into_glass(juicing_duration, $background/Glasses/P2, $pour1)
	on_depleted_health("P2", "P1")

var depletions_p2 = 0
func on_depleted_health2():
	depletions_p2 += 1
	$background.drain_into_glass(juicing_duration, $background/Glasses/P1, $pour2)
	on_depleted_health("P1", "P2")

func on_depleted_health(victor, ko):
	_enable_object(fighter1, false)
	_enable_object(fighter2, false)
	_enable_object($Mixer, false)
	_enable_object($MixerController, false)
	$MixerController.enabled = false
	$ui_overlay/battle_msg.text = ko + " K.O."
	$ui_overlay/battle_msg.show()
	$battle_restart_timer.start()
	$announce_ko.play()

func on_battle_restart_timer():
	$battle_restart_timer.stop()
	reset()
	if not depletions_p1 >= 2 and not depletions_p2 >= 2:
		countdown.start()
		var which_round = depletions_p1 + depletions_p2
		if which_round == 0:
			$announce_round1.play()
		elif which_round == 1:
			$announce_round2.play()
		elif which_round == 2:
			$announce_round3.play()
	else:
		var victor_str = "P1" if depletions_p2 >= 2 else "P2"
		var ko_obj = fighter2 if depletions_p2 >= 2 else fighter1
		ko_obj.hide()
		$ui_overlay/battle_msg.text = "Victory " + victor_str
		$ui_overlay/battle_msg.show()
		$ui_overlay/countdown.hide()
		$announce_victory.play()
	
func _enable_object(object, enabledness: bool):
	object.set_process(enabledness)
	object.set_physics_process(enabledness)
	object.set_process_input(enabledness)

func on_countdown_finished():
	_enable_object(fighter1, true)
	_enable_object(fighter2, true)
	_enable_object($Mixer, true)
	_enable_object($MixerController, false)
	$MixerController.enabled = true
