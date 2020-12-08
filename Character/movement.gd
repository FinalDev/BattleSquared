extends KinematicBody

onready var currentPath = ""
var follow = PathFollow.new()

#onready var interpolated = $Interpolated

export var	WalkSpeed:float 			= 9.0
export var	JumpForce:float 			= 18.0

const 		GRAVITY:float				= -9.8
const 		ACCEL:float	 				= 8.0
const 		DEACCEL:float				= 16.0

var			_Velocity:Vector3			= Vector3()
var			move_direction:Vector3 		= Vector3()

func _ready():
	change_path("Main") # This will need to be more modular based on where you get in/out of the levels


func change_path(path):
	if path != currentPath:
		print("Path change from %s to %s" % [currentPath, path])
		
		get_node("../Level/Paths/%s" % currentPath).remove_child(follow)
		get_node("../Level/Paths/%s" % path).add_child(follow)
		
		follow.offset = 0
		follow.rotation_mode = PathFollow.ROTATION_ORIENTED
		follow.loop = false
		
		get_node("../Level/Paths/%s" % path).get_curve().bake_interval=0.1
		
		currentPath = path
	else:
		print("%s to %s" % [currentPath, path])

#func _process(delta):
#	var fps = Engine.get_frames_per_second()
#	var lerp_interval = _Velocity / fps
#	var lerp_position = global_transform.origin + lerp_interval
#
#	if fps > ProjectSettings.get_setting("physics/common/physics_fps"):
#		interpolated.set_as_toplevel(true)
#		interpolated.global_transform.origin = interpolated.global_transform.origin.linear_interpolate(lerp_position, 20 * delta)
#		interpolated.rotation_degrees.y = follow.rotation_degrees.y - 90
#	else:
#		interpolated.global_transform = global_transform
#		interpolated.set_as_toplevel(false)
	

func _physics_process(delta):
	
	follow.offset = follow.get_parent().curve.get_closest_offset(translation)
	rotation.y = follow.rotation.y - deg2rad(90)
	
	translation.x = follow.translation.x
	translation.z = follow.translation.z
	
	move_direction = move_direction.rotated(Vector3.UP, rotation.y)
	
	if is_on_floor():
		# Acceleration / Decceleration
		var hvelocity = _Velocity
		hvelocity.y = 0
		
		var target = move_direction * WalkSpeed
		var accel
		if (move_direction.dot(hvelocity) > 0):
			accel = ACCEL
		else:
			accel = DEACCEL
		
		hvelocity = hvelocity.linear_interpolate(target, accel*delta)
		
		_Velocity.x = hvelocity.x
		_Velocity.z = hvelocity.z
	
	if !is_on_floor():
		#Drag
		_Velocity -= (_Velocity*0.02)*Vector3(1,0,1)
	
	#Gravity
	_Velocity.y += GRAVITY * delta * 4 #need fixing
	
	# Add direction
	_Velocity += move_direction * WalkSpeed * 5 * delta
	
	_Velocity = move_and_slide(_Velocity, Vector3(0, 1, 0), true, 72, deg2rad(72), false) #need slop fix
	
	#reset move_direction for next update.
	#move_direction = Vector3()
	
