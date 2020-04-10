extends KinematicBody

var follow = PathFollow.new()

export var	WalkSpeed:float 			= 9.0
export var	JumpForce:float 			= 18.0

const 		GRAVITY:float				= -9.8
const 		ACCEL:float	 				= 8.0
const 		DEACCEL:float				= 16.0

var			_Velocity:Vector3			= Vector3()

func _ready():
	$"../Path".add_child(follow)
	follow.offset = 0
	follow.rotation_mode = PathFollow.ROTATION_ORIENTED
	follow.loop = false

func _process(delta):
	var move_direction = Vector3()
	
	follow.offset = follow.get_parent().curve.get_closest_offset(translation)
	rotation.y = follow.rotation.y - deg2rad(90)
	
	translation.x = follow.translation.x
	translation.z = follow.translation.z
	
	#move_direction.x = int(Input.is_key_pressed(KEY_A)) - int(Input.is_key_pressed(KEY_D))
	move_direction.x = int(Input.is_action_pressed("movement_left")) - int(Input.is_action_pressed("movement_right"))
	if Input.is_action_pressed("movement_jump") and is_on_floor():
		_Velocity.y = JumpForce
	
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
	
	_Velocity = move_and_slide(_Velocity, Vector3(0, 1, 0), true, 1, deg2rad(60), false)
