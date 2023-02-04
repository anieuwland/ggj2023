extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func change_scene(var scene_path: String):
	while get_child_count() > 0:
		remove_child(get_child(0))
	var new_scene = load(scene_path).instance()
	add_child(new_scene)

func change_scene_to_node(var scene_node: Node):
	while get_child_count() > 0:
		remove_child(get_child(0))
	add_child(scene_node)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
