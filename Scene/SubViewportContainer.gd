extends SubViewportContainer

@export var height: int = 480
var margin = 4

func _ready():
	%PostProcessing.visible = true
	position = Vector2i(-2, -2)

func _process(_delta: float) -> void:
	var screen_size := Vector2(get_window().size)
	var pixel_scale := screen_size.y / height
	var game_size := Vector2i(round(screen_size.x/pixel_scale), height)+Vector2i(4,4)
	
	size = game_size
	scale = Vector2(pixel_scale, pixel_scale)
