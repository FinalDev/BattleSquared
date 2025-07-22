extends RichTextLabel

var debug_values: Dictionary = {}

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_F1:
			visible = !visible
			print("Debug Text is %s" % visible)

func add_debug_value(key, value):
	if not key in debug_values:
		debug_values[key] = ""
	
	debug_values[key] = value

func _process(_delta):
	add_debug_value("Current FPS", "%d" % Engine.get_frames_per_second())
	add_debug_value("Physic TPS", "%d" % Engine.physics_ticks_per_second)
	var lines = []
	for key in debug_values.keys():
		lines.append("%s: %s" % [key, debug_values[key]])
	text = "[outline_color=BLACK][outline_size=5]" + "\n".join(lines) + "[/outline_size][/outline_color]"
