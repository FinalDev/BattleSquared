extends "res://Character/movement.gd"

func _ready():
	pass
	
func _process(delta):
	move_direction = Vector3()
	
	move_direction.x = int(Input.is_action_pressed("movement_left")) - int(Input.is_action_pressed("movement_right"))
	if Input.is_action_pressed("movement_jump") and is_on_floor():
		_Velocity.y = JumpForce

#func _input(event):
#
