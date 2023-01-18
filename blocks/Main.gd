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

# キー用配列
const KEY_ARRAY = [
  ["ui_left", Vector2.LEFT],
  ["ui_right", Vector2.RIGHT]]

# 変数
var prev_time: float = 0
var cur_time: float = 0
var interval: float = INTERVAL

# シーン読み込み
onready var block_scene: PackedScene = preload("res://Block.tscn")

# ノード
onready var dynamic_layer: CanvasLayer = get_node("DynamicLayer")
onready var static_layer: CanvasLayer = get_node("StaticLayer")

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
 
  # 落下速度加速
  _move_block_y_fast()

  # 落下ブロックがなければ新たに作成
  if dynamic_layer.get_children().size() == 0:
    _create_block()

  # 左右移動
  _move_block_x()

  # 回転
  _rotate_block()

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
  
  var dynamic: Array = dynamic_layer.get_children()
  # 基準ブロック
  var org_block: Block = dynamic.front()
  org_block.position.x = get_viewport_rect().size.x / 2
  org_block.position.y = 0
  # 配置情報をもとにブロックを組み立てる
  for block in dynamic:
    var i: int = block.get_index()
    block.position = org_block.position + BLOCK_LAYOUT[type][i] * BLOCK_SIZE
    
# ブロック左右移動
func _move_block_x() -> void:
  # 配列ループ
  for item in KEY_ARRAY:
    # キー入力チェック
    if Input.is_action_just_pressed(item[0]):
      # 移動
      _move_block(item[1])
      # 両端チェックと固定ブロックとの当たり判定
      if _hit_edge() or _hit_static():
        # 1ブロック分戻す
        _move_block(item[1] * -1)      
      
# ブロック落下処理
func _move_block_y() -> void:
  # 1ブロック分落下
  _move_block(Vector2.DOWN)
  # 画面下到達か固定ブロックにヒット
  if _hit_bottom() or _hit_static():
    # 1ブロック上に戻す
    _move_block(Vector2.UP)
    # 固定ブロックへ追加
    _dynamic_to_static()

# ブロック加速落下処理
func _move_block()_y_fast -> void:
  # 下キー
  if Input.is_action_pressed("ui_down"):
    interval = INTERVAL * 0.5

# ブロック回転処理
func _rotate_block() -> void:
  # 上キー
  if Input.is_action_just_pressed("ui_up"):
    var dynamic: Array = dynamic_layer.get_children()
    # 度からラジアンへ変換
    var angle = deg2rad(90)
    # 回転の原点
    var point: Vector2 = dynamic.front().position
    # 原点を中心に回転後の座標を求める
    for block in dynamic:
      # 90度回転
      block.position = point + (block.position - point).rotated(angle)
    # 両端と固定ブロックと底との当たり判定
    if _hit_edge() or _hit_static() or _hit_bottom():
      # 回転を戻す
      for block in dynamic:
        block.position = point + (block.position - point).rotated(-1 * angle)

# 画面下到達チェック
func _hit_bottom() -> bool:
  for block in dynamic_layer.get_children():
    if block.position.y == BOTTOM_Y:
      return true
  return false

# 両端チェック
func _hit_edge() -> bool:
  for block in dynamic_layer.get_children():
    if (block.position.x < EDGE_LEFT) or (block.position.x > EDGE_RIGHT):
      return true
  return false

# 固定ブロックとの当たり判定
func _hit_static() -> bool:
  for block in dynamic_layer.get_children():
    for target in static_layer.get_children():
      # 位置が一致したら
      if block.position == target.position:
        return true
  return false
         
# 移動ブロックから固定ブロックへの変更処理
func _dynamic_to_static() -> void:
  # グループ間の移動
  for block in dynamic_layer.get_children():
    dynamic_layer.remove_child(block)
    static_layer.add_child(block)
    
