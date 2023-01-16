extends Node2D


# 定数
const BLOCK_SIZE = 40
const BLOCK_COLS = 10
const BLOCK_ROWS = 20
const BLOCK_TYPE = 7
const BOTTOM_Y = BLOCK_SIZE * BLOCK_ROWS
const EDGE_LEFT = BLOCK_SIZE * 3
const EDGE_RIGHT = BLOCK_SIZE * 12
const INTERVAL = 0.5

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
var interval: float = INTERVAL

# ノード
onready var dynamic_layer = get_node("DynamicLayer")
onready var static_layer = get_node("StaticLayer")

# シーン読み込み
onready var block_scene = preload("res://Block.tscn")

# 初期化処理
func _ready() -> void:
  pass

# 毎フレーム処理
func _process(delta) -> void:
  cur_time += delta
  # 一定時間毎にブロック落下
  if cur_time - prev_time > interval:
    _move_block_y()
    prev_time = cur_time
  # 落下ブロックがなければ新たに作成
  if dynamic_layer.get_children().size() == 0:
    _create_block()
  # 左右移動
  _move_block_x()

# 落下ブロック作成
func _create_block() -> void:
  # 種類をランダムに決める
  randomize()
  var type: int = randi() % BLOCK_TYPE
  # 落下ブロック作成
  for i in range(4):
    var block: Block = block_scene.instance()
    block.type = type
    # フレームインデックス設定
    block.get_node("Sprite").frame = type
    dynamic_layer.add_child(block)
    
  # 基準ブロック
  var org_block: Block = dynamic_layer.get_children().front()
  org_block.position.x = get_viewport_rect().size.x / 2
  org_block.position.y = 0
  # 配置情報をもとにブロックを組み立てる
  for block in dynamic_layer.get_children():
    var i = block.get_index()
    block.position = org_block.position + BLOCK_LAYOUT[type][i] * BLOCK_SIZE
    
# ブロック左右移動
func _move_block_x() -> void:
  # 左キー
  if Input.is_action_just_pressed("ui_left"):
    for block in dynamic_layer.get_children():
      # 左端で移動制限
      if block.position.x < EDGE_LEFT:
        return
    # 左移動
    for block in dynamic_layer.get_children():
      block.position.x -= BLOCK_SIZE

  # 右キー
  if Input.is_action_just_pressed("ui_right"):
    for block in dynamic_layer.get_children():
      # 右端で移動制限
      if block.position.x > BLOCK_RIGHT:
        return
    # 右移動
    for block in dynamic_layer.get_children():
      block.position.x += BLOCK_SIZE
      
# ブロック落下処理
func _move_block_y() -> void:
  # 1ブロック分落下
  for block in dynamic_layer.get_children():
    block.position.y += BLOCK_SIZE
  # 画面下到達チェック
  _check_hit_bottom()
  # 固定ブロックとの当たり判定
  _check_hit_static()

# 画面下到達チェック
func _check_hit_bottom() -> void:
  for block in dynamic_layer.get_children():
    if block.position.y == BOTTOM_Y:
      # 1ブロック分上に戻す
      for target in dynamic_layer.get_children():
        target.position.y -= BLOCK_SIZE
      # 移動ブロックから固定ブロックへ
      _dynamic_to_static()
      break

# 固定ブロックとの当たり判定
func _check_hit_static() -> void:
  for block in dynamic_layer.get_children():
    for target in static_layer.get_children():
      if block.position == target.position:
        # 1ブロック分上に戻す
        for block2 in dynamic_layer.get_children():
          block2.position.y -= BLOCK_SIZE
        # 移動ブロックから固定ブロックへ
        _dynamic_to_static()
        return
         
# 移動ブロックから固定ブロックへの変更処理
func _dynamic_to_static() -> void:
  # レイヤー間の移動
  for block in dynamic_layer.get_children():
    dynamic_layer.remove_child(block)
    static_layer.add_child(block)
