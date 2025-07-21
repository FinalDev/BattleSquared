@tool # Needed so it runs in editor.
extends EditorScenePostImport

const MAT = preload("res://Assets/FantasyKingdom/FantasyKingdom.tres")
var SceneRoot: Node
var SceneName: String

func _post_import(scene):
	SceneRoot = scene
	# Change all node names to "modified_[oldnodename]"
	iterate(scene)
	scene.name = SceneName
	return scene # Remember to return the imported scene

func iterate(node):
	if node != null:
		#print_rich("Post-import: [b]%s[/b] -> [b]%s[/b]" % [node.name, "modified_" + node.name])
		#node.name = "modified_" + node.name
					
			
		for child in node.get_children():
			iterate(child)
		if node is MeshInstance3D:
			SceneName = node.name
			node.set_surface_override_material(0, MAT)
			node.owner=null
			node.reparent(SceneRoot, false)
			node.owner=SceneRoot
		elif node is AnimationPlayer:
			node.queue_free()
		elif node != SceneRoot:
			if node.name != "RootNode":
				print("%s of type %s in %s" % [node.name, node.get_class(), SceneName])
			node.queue_free()
