class_name PathChanger extends Area3D

@export_node_path("Path3D") var targetPath

func _on_body_entered(body):
	print("enter")
	if body as Player:
		if body.currentPath != get_node(targetPath).name:
			body.change_path(get_node(targetPath).name)
