extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Piece_input_event(viewport, event, shape_idx):
	# マウス入力イベントが発生
	if event is InputEventMouseButton:
		# マウスボタンの押下イベント
		if event.is_pressed():
			# 親の関数を呼び出す
			get_parent().move_piece(self)
