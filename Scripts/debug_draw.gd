@tool
extends Node

@export var active:bool = true
@onready var path = $Paths

func _ready():
	# Set the base scoped_config.
	# Each frame will be reset to these scoped values.
	DebugDraw3D.scoped_config().set_thickness(0.1).set_center_brightness(0.6)

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_F2:
			active = !active

func draw():
	#DebugDraw3D.clear_all()
	
	#if Engine.is_editor_hint():
		#print("in editor")
	#else:
		#print("in game")
	#DebugDraw3D.config.geometry_render_layers = 2
	for child in path.get_children():
		if child is Path3D:
			var points:PackedVector3Array = []
			for point in child.curve.get_baked_points():
				points.append(point+child.position)
			#DebugDraw3D.draw_line_path(child.curve.get_baked_points(), Color(0, 1, 0), UPDATE_COOLDOWN+0.25)\
			#DebugDraw3D.draw_line_path(paths, Color(0, 1, 0), UPDATE_COOLDOWN+0.25)
			DebugDraw3D.draw_points(points, DebugDraw3D.POINT_TYPE_SQUARE, 0.05, Color(0, 1, 0), 0)
		elif child is PathChanger:
			var collision:CollisionShape3D = child.get_child(0)
			var pos = child.position+collision.position
			DebugDraw3D.draw_box(pos, child.quaternion, collision.shape.size, Color(0, 0, 1), true, 0)
		elif child is PathToggle:
			var collision:CollisionShape3D = child.get_child(0)
			var pos = child.position+collision.position
			DebugDraw3D.draw_box(pos, child.quaternion, collision.shape.size, Color(0, 1, 1), true, 0)
	for child in get_children():
		if child is LevelChanger:
			var collision:CollisionShape3D = child.get_child(0)
			var pos = child.position+collision.position
			DebugDraw3D.draw_box(pos, child.quaternion, collision.shape.size, Color(1, 0, 0), true, 0)

func _exit_tree():
	DebugDraw3D.clear_all()

func _process(_delta):
	if active:
		draw()
