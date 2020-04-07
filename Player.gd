extends KinematicBody

var follow = PathFollow.new()

func _ready():
	$"../Path".add_child(follow)
	follow.offset = 0
	follow.rotation_mode = PathFollow.ROTATION_ORIENTED
	follow.loop = false

func _process(delta):
	var dir = Vector2()
	if Input.is_key_pressed(KEY_A):
		dir.x += 1
	if Input.is_key_pressed(KEY_D):
		dir.x -= 1
		
	dir.normalized()
	
	follow.offset += dir.x * 5 * delta
	print(follow.offset)
	
	translation = follow.translation
	rotation.y = follow.rotation.y

