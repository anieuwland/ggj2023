extends Node2D


var health_max = 120.0
var health = 120.0 # 100 health points

onready var outline = $Outline
onready var healthMeter = $HealthMeter

signal health_depleted()


func _init():
	pass
	#update_healthbar(health)

func suffer(damage_):
	health = clamp(health - damage_, 0, health_max)
	update_healthbar(health)
	if health <= 0:
		emit_signal("health_depleted")
	return health
	
func heal(points):
	health = clamp(health + points, 0, health_max)
	update_healthbar(health)
	return health

func update_healthbar(health_):
	healthMeter.scale.x = (health_ / health_max)

func reset():
	health = health_max
	update_healthbar(health)
