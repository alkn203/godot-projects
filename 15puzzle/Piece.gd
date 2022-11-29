extends Area2D

# ピースタッチ時処理
func _on_Piece_input_event(viewport, event, shape_idx):
  # マウス入力イベントが発生
  if event is InputEventMouseButton:
    # マウスボタンの押下イベント
    if event.is_pressed():
      # 親の関数を呼び出す
      get_parent().move_piece(self)
