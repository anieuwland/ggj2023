extends Area2D

signal hit(area)

func _ready():
	connect("area_entered", self, "_on_area_entered")
	monitoring = false

func _on_area_entered(area: Area2D) -> void:
	emit_signal("hit", area)

func _damage_frame(enabled: bool) -> void:
	if enabled:
		monitoring = true
	else:
		monitoring = false

func _block_frame(enabled: bool) -> void:
	pass
