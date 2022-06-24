extends Area2D

func _on_Piece_input_event(viewport, event, shape_idx):
	# mouse click event
	if event is InputEventMouseButton and event.is_pressed():
		# call parent method
		get_parent().move_piece(self)
