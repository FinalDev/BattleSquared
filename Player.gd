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
	var dir = Vector3()
	var facing_direction = self.transform.basis
	
	if Input.is_key_pressed(KEY_A):
		dir += facing_direction.z
	if Input.is_key_pressed(KEY_D):
		dir += -facing_direction.z
	if  Input.is_key_pressed(KEY_SPACE) and is_on_floor():
		_Velocity.y = JumpForce
		
	dir.normalized()
	
	if is_on_floor():
		# Acceleration / Decceleration
		var hvelocity = _Velocity
		hvelocity.y = 0
		
		var target = dir*WalkSpeed
		var accel
		if (dir.dot(hvelocity) > 0):
			accel = ACCEL
		else:
			accel = DEACCEL
		
		hvelocity = hvelocity.linear_interpolate(target, accel*delta)
		
		_Velocity.x = hvelocity.x
		_Velocity.z = hvelocity.z
	
	if !is_on_floor():
		#Drag
		_Velocity -= (_Velocity*0.02)*Vector3(1,0,1)
	
	# Add direction
	_Velocity += dir * WalkSpeed * 5 * delta
	
	#Gravity
	_Velocity.y += GRAVITY * delta * 4 #need fixing
	
	translation.x = follow.translation.x
	translation.z = follow.translation.z
	
	
	_Velocity = move_and_slide(_Velocity, Vector3(0, 1, 0), true, 4, deg2rad(45), false)
	
	follow.offset = follow.get_parent().curve.get_closest_offset(translation)
	rotation.y = follow.rotation.y

