class_name PathToggle extends Area3D

@export_node_path("Path3D") var path_1
@export_node_path("Path3D") var path_2
@onready var label = $Label

var body = null

func _input(event):
	if body and event.is_action_pressed("interact"):
		var current_path = get_node(path_1).name
		if body.currentPath == current_path:
			current_path = get_node(path_2).name
			
		body.change_path(current_path)

func _on_body_entered(_body):
	if _body as Player:
		body = _body
		label.visible = true

func _on_body_exited(_body):
	if _body as Player:
		body = null
		label.visible = false
