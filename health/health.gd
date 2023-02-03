extends ProgressBar


var health_max = 120.0
var health = 120.0 # 100 health points
var damage = 10.0 # 10 damage


func _init():
	print("Hello, world!")
	update_healthbar(health)


func _ready():
	pass


func _process(delta):
#func _physics_process(delta):
	get_input()


func get_input():
	if Input.is_action_pressed('debug_health_space'):
		print("DAMAGE ", health, " ", value)
		suffer(damage)

func suffer(damage):
	health = clamp(health - damage, 0, health_max)
	update_healthbar(health)
	return health
	
func heal(points):
	health = clamp(health + points, 0, health_max)
	update_healthbar(health)
	return health

func update_healthbar(health):
	value = (health / health_max) * 100.0
