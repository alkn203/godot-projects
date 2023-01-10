extends Node2D


# 定数
const BLOCK_SIZE = 40
const BLOCK_COLS = 10
const BLOCK_ROWS = 20
const BOTTOM_Y = BLOCK_SIZE * BLOCK_LOWS
const BLOCK_ALL_WIDTH = BLOCK_SIZE * BLOCK_COLS
const BLOCK_ALL_HEIGHT = BLOCK_ALL_WIDTH * 2
const INTERVAL = 1.0

# ブロック(7種)の配置情報
const BLOCK_LAYOUT = [
  [Vector2(0, 0), Vector2(0, -1), Vector2(0, -2), Vector2(0, 1)],
  [Vector2(0, 0), Vector2(0, -1), Vector2(0, 1), Vector2(1, 1)],
  [Vector2(0, 0), Vector2(0, -1), Vector2(0, 1), Vector2(-1, 1)],
  [Vector2(0, 0), Vector2(0, -1), Vector2(-1, -1), Vector2(1, 0)],
  [Vector2(0, 0), Vector2(0, -1), Vector2(1, -1), Vector2(-1, 0)],
  [Vector2(0, 0), Vector2(1, 0), Vector2(-1, 0), Vector2(0, -1)],
  [Vector2(0, 0), Vector2(0, -1), Vector2(1, -1), Vector2(1, 0)]]

# 変数
var prev_time: float = 0
var cur_time: float = 0
var interval: float

# ノード
onready var dynamic_layer = get_node("DynamicLayer")
# シーン読み込み
onready var block_scene = preload("res://Block.tscn")

# 初期化処理
func _ready() -> void:
  interval = INTERVAL
  #
  _create_block()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  cur_time += delta

  if cur_time - prev_time > interval:
    _move_block_y()
    prev_time = cur_time

# 落下ブロック作成
func _create_block() -> void:
  # 種類をランダムに決める
  randomize()
#  var type = randi() % 7 + 1
  var type = 0
  # 落下ブロック作成
  for i in range(4):
    var block: Block = block_scene.instance()
    block.type = type
    dynamic_layer.add_child(block)
    
  # 基準ブロック
  var org_block: Block = dynamic_layer.get_children().front()
  org_block.position.x = get_viewport_rect().size.x / 2
  org_block.position.y = 200
  # 配置情報をもとにブロックを組み立てる
  for block in dynamic_layer.get_children():
    var i = block.get_index()
    block.position = org_block.position + BLOCK_LAYOUT[type][i] * BLOCK_SIZE
    
# ブロック落下処理
func _move_block_y() -> void:
  # 1ブロック分落下
  for block in dynamic_layer.get_children():
    block.position.y += BLOCK_SIZE
  # 画面下到達チェック
  for block in dynamic_layer.get_children():
    if block.y == BOTTOM_Y:
      # 1ブロック分上に戻す
      for block in dynamic_layer.get_children():
        block.y -= BLOCK_SIZE
      # 移動ブロックから固定ブロックへ
      _dynamic_to_static()
      break

# 移動ブロックから固定ブロックへの変更処理
func _dynamic_to_static() -> void:


      

