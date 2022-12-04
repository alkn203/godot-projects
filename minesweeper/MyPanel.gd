extends Area2D
class_name MyPanel

# 変数
var is_bomb: bool = false
var is_open: bool = false

# パネルへの入力イベント
func _on_MyPanel_input_event(viewport, event, shape_idx):
   # マウス入力イベント
  if event is InputEventMouseButton: 
    # マウスボタン押下 
    if event.is_pressed(): 
      get_parent().open_panel(self)
