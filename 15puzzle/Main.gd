extends Node2D

const PIECE_SIZE = 64

# Called when the node enters the scene tree for the first time.
func _ready():
	for piece in get_children():
		var num = piece.get_index()
		# Set frame
		piece.find_node("Sprite").frame = num

func move_piece(piece):
	# get blank piece
	var blank = get_node("Piece16")
	
	var px = piece.position.x
	var py = piece.position.y
	var bx = blank.position.x
	var by = blank.position.y
	var dx = abs(px - bx)
	var dy = abs(py - by)
	# swap piece
	if (px == bx and dy == PIECE_SIZE) or (py == by and dx == PIECE_SIZE) :
		var tmp = Vector2.ZERO
		tmp = piece.position
		piece.position = blank.position
		blank.position = tmp
