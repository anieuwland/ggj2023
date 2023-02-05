tool
extends NinePatchRect

export(String) var text = "[insert text]" setget _set_text
onready var textfield: RichTextLabel = $RichTextLabel

func _set_text(newtext: String) -> void:
	textfield.text = newtext
