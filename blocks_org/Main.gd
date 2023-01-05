extends Node2D


# 定数
const BLOCK_SIZE = 40
const BLOCK_COLS = 10
const BLOCK_ROWS = 20
const BLOCK_ALL_WIDTH = BLOCK_SIZE * BLOCK_COLS
const BLOCK_ALL_HEIGHT = BLOCK_ALL_WIDTH * 2
#var INTERVAL = 20

# ブロック(7種)の配置情報
const BLOCK_LAYOUT = [
  [Vector2(0, 0), Vector2(0, -1), Vector2(0, -2), Vector2(0, 1)],
  [Vector2(0, 0), Vector2(0, -1), Vector2(0, 1), Vector2(1, 1)],
  [Vector2(0, 0), Vector2(0, -1), Vector2(0, 1), Vector2(-1, 1)],
  [Vector2(0, 0), Vector2(0, -1), Vector2(-1, -1), Vector2(1, 0)],
  [Vector2(0, 0), Vector2(0, -1), Vector2(1, -1), Vector2(-1, 0)],
  [Vector2(0, 0), Vector2(1, 0), Vector2(-1, 0), Vector2(0, -1)],
  [Vector2(0, 0), Vector2(0, -1), Vector2(1, -1), Vector2(1, 0)]]

# ノード
onready var dynamic_layer = get_node("DynamicLayer")
# シーン読み込み
onready var block_scene = preload("res://Block.tscn")

# 初期化処理.
func _ready():
  #
  _create_block()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass

# 落下ブロック作成
func _create_block() -> void:
  # 種類をランダムに決める
  randomize()
#  var type = randi() % 7 + 1
  var type = 0
  # 落下ブロック作成
  for i in range(4):
    var block = block_scene.instance()
    block.type = type
    dynamic_layer.add_child(block)
    
  # 基準ブロック
  var orgin_block: Block = dynamic_layer.get_children().front()
  orgin_block.position.x = get_viewport_rect().size.x / 2
  orgin_block.position.y = 200
  # 配置情報をもとにブロックを組み立てる
  for block in dynamic_layer.get_children():
    var i = block.get_index()
    block.position.x = orgin_block.position.x + BLOCK_LAYOUT[type][i].x * BLOCK_SIZE;
    block.position.y = orgin_block.position.y + BLOCK_LAYOUT[type][i].y * BLOCK_SIZE;
