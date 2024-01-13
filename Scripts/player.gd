class_name Player extends CharacterBody3D

@onready var currentPath = null
var follow: PathFollow3D

@onready var interpolated: Node3D = $Interpolated

@onready var ap: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite3D = $Interpolated/Sprite3D
@onready var state_machine = $StateMachine

@export var	WALKSPEED:float 		= 8.0
@export var	AIRSPEED:float 			= 6.0
@export var	JUMPFORCE:float 		= 15.0

var 		GRAVITY:float			= ProjectSettings.get_setting("physics/3d/default_gravity")
var 		ACCEL:float	 			= 0.1
var 		DEACCEL:float			= 0.25
var			direction:float
var			current_speed:float

var combo_array: Array = []
var combo_last_time: float = 0
var combo_list = {
	"light": ["light", "light", "light"],
	"heavy": ["heavy", "heavy", "heavy"],
	"slam": ["light", "light", "heavy"]
}

func _ready():
	follow = PathFollow3D.new()
	follow.rotation_mode = PathFollow3D.ROTATION_Y #PathFollow3D.ROTATION_ORIENTED
	follow.loop = false
	change_path("Main") # This will need to be more modular based on where you get in/out of the levels

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				combo_add("light")
			MOUSE_BUTTON_RIGHT:
				combo_add("heavy")

func combo_add(string: String):
	var curr_time = Time.get_ticks_msec()
	var time_since = (curr_time - combo_last_time) / 1000
	if time_since > 1.0:
		combo_array = []
	
	if combo_array.size() == 0:
		combo_last_time = curr_time
	
	combo_array.append(string)
	
	if combo_array.size() >= 3:
		var found = false
		for k in combo_list:
			if combo_array == combo_list[k]:
				found = true
				print("%s attack -> %s" % [k, str(combo_array)])
				break
		if not found:
			print("no combo for %s" % str(combo_array))
		
		combo_array = []

func change_path(path):
	if path != currentPath:
		print("Path3D change from %s to %s" % [currentPath, path])

		if currentPath != null:
			get_node("../Level/Paths/%s" % currentPath).remove_child(follow)
		get_node("../Level/Paths/%s" % path).add_child(follow)
		
		get_node("../Level/Paths/%s" % path).get_curve().bake_interval=0.1
		
		currentPath = path
		Global.debug_values.add_debug_value("Path", "%s" % currentPath)
	else:
		print("%s to %s" % [currentPath, path])

func get_direction():
	direction = Input.get_axis("movement_left", "movement_right")
	if direction != 0:
		sprite.flip_h = direction == -1
		sprite.offset.x = 4*direction

func move():
	if direction != 0:
		var move_direction = (transform.basis * Vector3(0.0, 0.0, direction)).normalized()
		velocity.x = lerp(velocity.x, move_direction.x * current_speed, ACCEL)
		velocity.z = lerp(velocity.z, move_direction.z * current_speed, ACCEL)
	else:
		velocity.x = move_toward(velocity.x, 0, DEACCEL)
		velocity.z = move_toward(velocity.z, 0, DEACCEL)

func jump():
	velocity.y = JUMPFORCE
	state_machine.change_state("midair")

func _physics_process(delta):
	
	follow.progress = follow.get_parent().curve.get_closest_offset(position)	
	position.x = follow.position.x
	position.z = follow.position.z
	rotation.y = follow.rotation.y
	
	state_machine.state_physics_process(delta)
	
	velocity.y -= GRAVITY*3*delta
	
	Global.debug_values.add_debug_value("Velocity", "%.3v" % velocity)
	Global.debug_values.add_debug_value("Direction", "%d" % direction)
	
	move_and_slide()

func _on_idle_state_enter():
	ap.play("idle")
	
func _on_idle_state_physics_update(_delta):
	get_direction()
	if direction != 0:
		state_machine.change_state("walking")
		return
		
	if Input.is_action_pressed("movement_jump") and is_on_floor():
		jump()
		return
		
	if not is_on_floor():
		state_machine.change_state("midair")
		return
		
	velocity.x = move_toward(velocity.x, 0, DEACCEL)
	velocity.z = move_toward(velocity.z, 0, DEACCEL)


func _on_walking_state_enter():
	ap.play("run")
	current_speed = WALKSPEED


func _on_walking_state_physics_update(_delta):
	get_direction()
	if direction == 0:
		state_machine.change_state("idle")
		return
	
	var h_velocity: float = Vector3(velocity.x, 0.0, velocity.z).dot(transform.basis.z)
	#Global.debug_values.add_debug_value("h_velocity", "%.3f" % h_velocity)
	if direction != sign(h_velocity):
		ap.play("turn_around", -1, 2)
		sprite.flip_h = -direction == -1
		sprite.offset.x = 4*-direction
	else:
		ap.play("run")
	
	if Input.is_action_pressed("roll") and is_on_floor():
		state_machine.change_state("roll")
		return
	
	if Input.is_action_pressed("movement_jump") and is_on_floor():
		jump()
		return
	
	if not is_on_floor():
		state_machine.change_state("midair")
		return
	
	move()

func _on_midair_state_enter():
	current_speed = AIRSPEED

func _on_midair_state_physics_update(_delta):
	get_direction()
	
	if velocity.y > 0:
		ap.play("jump")
	else:
		ap.play("fall")
		
	if is_on_floor():
		state_machine.change_state("idle")
		return
	
	move()

func _on_roll_state_enter():
	ap.play("roll", -1, 2)
	ap.animation_finished.connect(_on_roll_finish)
	
	velocity = transform.basis * Vector3(0.0, 5, 12*direction)


func _on_roll_state_physics_update(_delta):
	pass

func _on_roll_finish(_animation_name):
	if is_on_floor():
		state_machine.change_state("idle")
	else:
		state_machine.change_state("midair")
	ap.animation_finished.disconnect(_on_roll_finish)
