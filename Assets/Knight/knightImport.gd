@tool # Needed so it runs in editor.
extends EditorScenePostImport

const MAT = preload("res://Assets/Knight/POLYGON_Knights_Texture_01.tres")
var SceneRoot: Node

func _post_import(scene):
	SceneRoot = scene
	# Change all node names to "modified_[oldnodename]"
	iterate(scene)
	return scene # Remember to return the imported scene

func iterate(node):
	if node != null:
		#print_rich("Post-import: [b]%s[/b] -> [b]%s[/b]" % [node.name, "modified_" + node.name])
		#node.name = "modified_" + node.name
		if node is MeshInstance3D:
			node.set_surface_override_material(0, MAT)
			node.reparent(SceneRoot)
		elif node is AnimationPlayer:
			node.queue_free()
		for child in node.get_children():
			iterate(child)
