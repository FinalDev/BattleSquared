extends Node

@onready var world = $"../World"
var debug_values

func _ready():
	Engine.max_fps = 144
	Engine.physics_ticks_per_second = 60
	debug_values = world.get_node("DebugValues")
