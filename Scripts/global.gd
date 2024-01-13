extends Node

var debug_values
@onready var world = $"../World"


func _ready():
	Engine.max_fps = 144
	Engine.physics_ticks_per_second = 60
