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
  var len = get_tree().get_nodes_in_group("dynamic").size()
  if len == 0:
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
  
  var children: Array = dynamic_layer.get_children()
  # 基準ブロック
  var org_block: Block = children.front()
  org_block.position.x = get_viewport_rect().size.x / 2
  org_block.position.y = 0
  # 配置情報をもとにブロックを組み立てる
  for block in children:
    var i = block.get_index()
    block.position = org_block.position + BLOCK_LAYOUT[type][i] * BLOCK_SIZE
    
# ブロック左右移動
func _move_block_x() -> void:
  var dynamic: Array = get_tree().get_nodes_in_group("dynamic")
  # 左キー
  if Input.is_action_just_pressed("ui_left"):
    # 両端チェック
    
        return
    
    # 固定ブロックとの当たり判定
    
    # 左移動
    for block in children:
      block.position.x -= BLOCK_SIZE

  # 右キー
  if Input.is_action_just_pressed("ui_right"):
    for block in children:
      # 右端で移動制限
      if block.position.x > EDGE_RIGHT:
        return
    # 右移動
    for block in children:
      block.position.x += BLOCK_SIZE
      
# ブロック落下処理
func _move_block_y() -> void:
  # 1ブロック分落下
  _move_block(Vector2,DOWN)
  # 画面下到達か固定ブロックにヒット
  if _check_hit_bottom() or _check_hit_static():
    # 1ブロック上に戻す
    _move_block(Vector2.UP)
    # 固定ブロックへ追加
    _dynamic_to_static()
  
# ブロック移動処理
func _move_block(vec: Vector2) -> void:
  var dynamic: Array = get_tree().get_nodes_in_group("dynamic")

  for block in dynamic:
    block.position += vec * BLOCK_SIZE

# ブロック回転処理
func _rotate_block() -> void:
  # 上キー
  if Input.is_action_just_pressed("ui_up"):
    var children = dynamic_layer.get_children()
    # 度からラジアンへ変換
    var angle = deg_to_rad(90)
    # 回転の原点
    var point = children
    for block in dynamic_layer.get_children():
      # 90度回転
      block.position = point + (block.position - point).rotated(angle)

# 画面下到達チェック
func _check_hit_bottom() -> bool:
  var dynamic: Array = get_tree().get_nodes_in_group("dynamic")

  for block in dynamic:
    if block.position.y == BOTTOM_Y:
      return true
  return false

# 両端チェック
func _check_edge(): -> bool:
  for block in dynamic:
    if block.position.x < EDGE_LEFT:
  

# 固定ブロックとの当たり判定
func _check_hit_static() -> bool:
  var dynamic: Array = get_tree().get_nodes_in_group("dynamic")
  var static: Array = get_tree().get_nodes_in_group("static")

  for block in dynamic:
    for target in static:
      if block.position == target.position:
      return true
  return false
         
# 移動ブロックから固定ブロックへの変更処理
func _dynamic_to_static() -> void:
  var dynamic: Array = get_tree().get_nodes_in_group("dynamic")
  # グループ間の移動
  for block in dynamic:
    block.remove_from_group("dynamic")
    block.add_to_group("static")
