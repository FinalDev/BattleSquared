extends Node

@onready var player = $Character

func change_level(level_path: String, target_portal: String):
	get_node("/root/World/Level/Paths/%s" % player.currentPath).remove_child(player.follow)
	
	var level = get_node("Level")
	remove_child(level)
	level.call_deferred("free")
	
	var next_level = load(level_path).instantiate()
	next_level.name = "Level"
	add_child(next_level)
	
	var portal_node: Node = get_node("Level/%s" % target_portal)
	var new_pos = Vector3.ZERO
	if portal_node:
		new_pos = portal_node.position
		var portal_path: NodePath = portal_node.portal_path
		var path_name = portal_path.get_name(portal_path.get_name_count()-1)
		var path_node = get_node("/root/World/Level/Paths/%s" % path_name)
		player.currentPath = null
		player.change_path(path_node.name)
		
	player.follow.progress = player.follow.get_parent().curve.get_closest_offset(new_pos)
	player.position = new_pos
