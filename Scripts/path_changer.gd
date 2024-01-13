class_name PathChanger extends Area3D

@export_node_path("Path3D") var targetPath

func _on_Area_body_entered(body):
	if body as Player:
		if body.currentPath != get_node(targetPath).name:
			if is_instance_valid(get_node(targetPath)):
				body.change_path(get_node(targetPath).name)
			else:
				print("Forgot to assign a target path")
