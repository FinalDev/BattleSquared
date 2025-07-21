extends Camera3D

@onready var player = %Player

func _process(_delta):
	transform = player.camera_3d.global_transform
	Global.debug_values.add_debug_value("Camera Origin", "%.3v" % transform.origin)
	Global.debug_values.add_debug_value("Camera Rotation", "%.3v" % rotation_degrees)
