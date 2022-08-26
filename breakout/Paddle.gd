extends KinematicBody2D


# Declare member variables here. Examples:
var sprite_size = get_node("Sprite").texture.get_size()
onready var screen_size = get_viewport_rect().size


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# マウス位置取得
	var pos = get_viewport().get_mouse_position()
	# パドルの横座標を追従させ、画面からはみ出ないようにする
	var pos_min = sprite_size.x / 2
	var pos_max = screen_size.x - sprite_size.x / 2
	position.x = clamp(pos.x, pos_min, pos_max)
