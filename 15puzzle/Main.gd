extends Node2D


# Declare member variables here. Examples:
onready var blank = get_node("Piece16")
var PIECE_SIZE = 160;


# Called when the node enters the scene tree for the first time.
func _ready():
	for piece in get_children():
		var index = piece.get_index()
		piece.get_node("Sprite").frame = index


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func move_piece(piece):
	var p_pos = piece.position
	var b_pos = blank.position
	# x, yの座標差の絶対値
	var dx = abs(p_pos.x - b_pos.x);
	var dy = abs(p_pos.y - b_pos.y);
	# 隣り合わせの判定
	if ((p_pos.x == b_pos.x and dy == PIECE_SIZE) or (p_pos.y == b_pos.y and dx == PIECE_SIZE)):
		# タッチされたピース位置を一時変数に退避
		var t_pos = Vector2(p_pos.x, p_pos.y)
		# ピース入れ替え処理
		piece.position = b_pos
		blank.position = t_pos
