class_name MyPanel
extends Area2D

# 変数
var index_pos: Vecror2 = Vector2.ZERO
var is_bomb: bool = false
var is_open: bool = false

# シーン
onready var main_scene = get_node("/root/Main")

# パネルへの入力イベント
func _on_MyPanel_input_event(viewport, event, shape_idx):
   # マウス入力イベント
  if event is InputEventMouseButton: 
    # マウスボタン押下 
    if event.is_pressed(): 
      main_scene.open_panel(self)
