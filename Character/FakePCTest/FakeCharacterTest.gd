extends "res://Character/movement.gd"

func _ready():
	pass

func _process(_delta):
	var dir:int = 0
	if Input.is_key_pressed(KEY_RIGHT):
		dir -= 1
	if Input.is_key_pressed(KEY_LEFT):
		dir += 1
	if Input.is_key_pressed(KEY_UP) and is_on_floor():
		_Velocity.y = JumpForce
	
	move_direction.x = dir
