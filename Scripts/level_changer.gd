class_name LevelChanger extends Area3D

@export_file() var level_path
@export var target_portal: String
@export_node_path("Path3D") var portal_path
@onready var label = $Label

var interactable = false

func _input(event):
	if interactable and event.is_action_pressed("interact"):
		Global.world.change_level(level_path, target_portal)

func _on_body_entered(_body):
	interactable = true
	label.visible = true

func _on_body_exited(_body):
	interactable = false
	label.visible = false
