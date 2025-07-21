extends Control

@export var viewport: SubViewportContainer
@export var height: int = 480
@onready var _sprite: Sprite2D = $Sprite2D


func _ready():
	%PostProcessing.visible = true

func _process(_delta: float) -> void:
	var screen_size := Vector2(get_window().size)
	var pixel_scale := screen_size.y / height
	var game_size := Vector2(screen_size.x/pixel_scale, height)+Vector2(4, 4)
	
	viewport.size = game_size
	_sprite.scale = Vector2(pixel_scale, pixel_scale)
	
	# scale and center control node
	size = (_sprite.scale * game_size).round()
	position = ((screen_size - size) / 2).round()

