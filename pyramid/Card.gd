extends Area2D

# 変数
var index
var num

# ノード取得
onready var main = get_node("/root/Main")


# Called when the node enters the scene tree for the first time.
func _ready():
  index = 0
  num = 0

# Called every frame. 'delta' is time since the previous frame.
#func _process(delta):
#	pass

func _on_Gem_input_event(viewport, event, shape_idx):
  # マウス入力イベントが発生
  if event is InputEventMouseButton:
    # マウスボタンの押下イベント
    if event.is_pressed():
      # Mainの関数に自身を渡す
      main.select_pair(self)

# インデックスと数字セット
func set_index_number(idx):
  index = idx
  num = index % 13 + 1
