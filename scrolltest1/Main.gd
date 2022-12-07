extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# ノード
onready var player = get_node("Player")
onready var camera = get_node("Camera2D")

# Called when the node enters the scene tree for the first time.
func _ready():
  pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  camera.position.x = player.position.x - 400
