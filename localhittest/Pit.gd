extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var speed = 2
var deg

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  deg += speed
  position.x = 64 * cos(deg2rad(deg))
  position.y = 64 * sin(deg2rad(deg))
