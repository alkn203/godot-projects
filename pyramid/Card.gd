extends Area2D

# 定数
const DURATION = 0.25

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

# マウスクリック時イベント
func _on_Card_input_event(viewport, event, shape_idx):
  # マウス入力イベントが発生
  if event is InputEventMouseButton:
    # マウスボタンの押下イベント
    if event.is_pressed():
      # Mainの関数に自身を渡す
      main.add_pair(self)

# インデックスと数字セット
func set_index_num(idx):
  index = idx
  num = index % 13 + 1
  
# カード返し処理
func flip():
  # アニメーション：絵柄のフレームにして選択可能にする
  var tween = get_tree().create_tween()
  tween.tween_property(self, "scale", Vector2(0.1, 1.0), DURATION)
  tween.tween_callback(self, "_set_frame_index")
  tween.tween_property(self, "scale", Vector2(1.0, 1.0), DURATION)

# カード表の画像フレームをセット
func _set_frame_index():
  get_node("Sprite").frame = index
