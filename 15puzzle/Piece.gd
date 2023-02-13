class_name Piece
extends Area2D

# ノード
onready const main: Node2D = get_node("/root/Main")

# インデックス位置
var index_pos: Vector2 = Vector2.ZERO

# タッチ時処理
func _on_Piece_input_event(viewport, event, shape_idx) -> void:
  # マウス入力イベント
  if event is InputEventMouseButton:
    # マウスボタンの押下
    if event.is_pressed():
      # メインシーンの関数を呼んで自身を渡す
      main.move_piece(self)
