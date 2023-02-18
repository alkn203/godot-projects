extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (int) var frame_index = 0


# Called when the node enters the scene tree for the first time.
func _ready():
  get_node("Sprite").frame = frame_index


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
