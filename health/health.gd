extends Node2D

export(Color) var health_color: Color

var health_max = 120.0
var health = 120.0 # 100 health points

onready var outline = $Outline
onready var health_meter = $HealthMeter

signal health_depleted()

func _ready():
	outline.default_color = health_color
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
	health_meter.scale.x = (health_ / health_max)

func reset():
	health = health_max
	update_healthbar(health)
