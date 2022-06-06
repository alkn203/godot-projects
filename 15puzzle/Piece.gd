extends Area2D

# Called when the node enters the scene tree for the first time.
#func _ready():
# pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Piece_input_event(viewport, event, shape_idx):
	# 何らかの入力イベントが発生
	if event is InputEventMouseButton:
		# マウスボタンの入力イベント
		if event.is_pressed():
			get_parent()._test(self)
