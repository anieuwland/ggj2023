extends Area2D

signal hit(area)
signal start_block()
signal stop_block()
signal kick()
var action_active: bool = false

onready var smileface: Node2D = $"../../../../../../visuals/smileface"
onready var happyface: Node2D = $"../../../../../../visuals/happyface"
onready var cryface: Node2D = $"../../../../../../visuals/cryface"
onready var animation: AnimationTree = $"../../../../../../animation"

func _ready():
	connect("area_entered", self, "_on_area_entered")
	monitoring = false

func _on_area_entered(area: Area2D) -> void:
	emit_signal("hit", area)
	
func reset_action() -> void:
	action_active = false
	monitoring = false

func _damage_frame(enabled: bool) -> void:
#	smileface.visible = not enabled
#	happyface.visible = enabled
	if enabled:
		monitoring = true
		action_active = true
	else:
		monitoring = false
		action_active = false

func _block_frame(enabled: bool) -> void:
	if enabled:
		emit_signal("start_block")
		action_active = true
	else:
		emit_signal("stop_block")
		action_active = false

func _grab_frame(enabled: bool) -> void:
	if enabled:
		monitoring = true
		action_active = true
	else:
		monitoring = false
		action_active = false
		
func _kick_frame(enabled: bool) -> void:
	if enabled:
		reset_action()
		emit_signal("kick")
