extends ProgressBar


var health_max = 120.0
var health = 120.0 # 100 health points
var damage = 10.0 # 10 damage

signal health_depleted()


func _init():
	update_healthbar(health)

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
	value = (health_ / health_max) * 100.0

func reset():
	health = health_max
	update_healthbar(health)
