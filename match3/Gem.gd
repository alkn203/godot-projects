extends Area2D
class_name Gem

# 変数
var num: int = 0
var mark: String = "normal"
var drop_count: int = 0

# ノード取得
onready var main: Node2D = get_node("/root/Main")

# クリック時処理
func _on_Gem_input_event(viewport, event, shape_idx):
  # マウス入力
  if event is InputEventMouseButton:
    # マウスボタンの押下
    if event.is_pressed():
      # Mainの関数に自身を渡す
      main.select_pair(self)
