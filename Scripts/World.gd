extends Node

@onready var player = %Player
@onready var level_path = "/root/World/%s" % get_path_to(%Level)

func change_level(scene_path: String, target_portal: String):
	get_node("%s/Paths/%s" % [level_path, player.currentPath]).remove_child(player.follow)
	
	var level = get_node(level_path)
	var level_parent = level.get_parent()
	level_parent.remove_child(level)
	level.call_deferred("free")
	
	var next_level = load(scene_path).instantiate()
	next_level.name = "Level"
	level_parent.add_child(next_level)
	
	var portal_node: Node = get_node("%s/%s" % [level_path, target_portal])
	var new_pos = Vector3.ZERO
	if portal_node:
		new_pos = portal_node.position
		var portal_path: NodePath = portal_node.portal_path
		var path_name = portal_path.get_name(portal_path.get_name_count()-1)
		var path_node = get_node("%s/Paths/%s" % [level_path, path_name])
		player.currentPath = null
		player.change_path(path_node.name)
		
	player.follow.progress = player.follow.get_parent().curve.get_closest_offset(new_pos)
	player.position = new_pos
