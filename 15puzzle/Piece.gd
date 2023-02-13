class_name Piece
extends Area2D


# タッチ時処理
func _on_Piece_input_event(viewport, event, shape_idx) -> void:
  # マウス入力イベント
  if event is InputEventMouseButton:
    # マウスボタンの押下
    if event.is_pressed():
      # 親の関数を呼んで自身を渡す
      get_parent().move_piece(self)
