extends Node3D

@onready var target = $".."

var smooth_tr_prev: Transform3D
var smooth_tr_curr: Transform3D

func _ready():
	smooth_tr_prev = Transform3D()
	smooth_tr_curr = Transform3D()
	set_process_priority(100)
	set_as_top_level(true)
	Engine.set_physics_jitter_fix(0.0)

func _process(_delta):
	var phys_frame = Engine.get_physics_interpolation_fraction()
	var smooth_tr: Transform3D = Transform3D()

	var smooth_tr_diff = smooth_tr_curr.origin - smooth_tr_prev.origin
	smooth_tr.origin = smooth_tr_prev.origin + (smooth_tr_diff * phys_frame)
	
	smooth_tr.basis = smooth_tr_prev.basis.slerp(smooth_tr_curr.basis, phys_frame)
	
	transform = smooth_tr
	
func _physics_process(_delta):
	smooth_tr_prev = smooth_tr_curr
	smooth_tr_curr = target.global_transform
	smooth_tr_curr.basis = smooth_tr_curr.basis.orthonormalized()
