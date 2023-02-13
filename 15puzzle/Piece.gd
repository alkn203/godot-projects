class_name Piece
extends Area2D

# インデックス位置
var index_pos: Vector2 = Vector2.ZERO

# ノード
onready var main: Node2D = get_node("/root/Main")

# タッチ時処理
func _on_Piece_input_event(_viewport, event, _shape_idx) -> void:
  # マウス入力イベント
  if event is InputEventMouseButton:
    # マウスボタンの押下
    if event.is_pressed():
      # メインシーンの関数を呼んで自身を渡す
      main.move_piece(self)
