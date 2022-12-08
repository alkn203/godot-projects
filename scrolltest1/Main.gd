extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# ノード
onready var player = get_node("Player")
onready var camera = get_node("Camera2D")
onready var screen_size = get_viewport_rect().size

# Called when the node enters the scene tree for the first time.
func _ready():
  #
  var cx = screen_size.x / 2
  var cy = screen_size.y / 2
  #
  camera.position = Vector2(cx, cy)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  #camera.position.x = player.position.x - 400
  pass
_
