extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	for piece in get_children():
		var num = piece.get_index()
		# Set frame
		piece.find_node("Sprite").set("frame", num)

func _test(piece):
	print(piece.position)
