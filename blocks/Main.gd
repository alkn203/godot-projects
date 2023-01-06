extends Node2D


# 定数
const BLOCK_SIZE = 40
const BLOCK_COLS = 10
const BLOCK_ROWS = 20
const BLOCK_ALL_WIDTH = BLOCK_SIZE * BLOCK_COLS
const BLOCK_ALL_HEIGHT = BLOCK_ALL_WIDTH * 2
const INTERVAL = 1.0

# 変数
var prev_time:float = 0
var cur_time: float = 0
var interval: float

onready var label = get_node("Label")

# 初期化処理.
func _ready():
  interval = INTERVAL
  #
  _create_block()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  cur_time += delta
  label.text = str(cur_time)

  if cur_time - prev_time > interval:
    _move_block_y()
    prev_time = cur_time

# 落下ブロック作成
func _create_block() -> void:
  # 種類をランダムに決める
  randomize()
#  var type = randi() % 7 + 1
  var type = 4
  # ブロック作成
  var block_scene = load("res://Block" + str(type) + ".tscn")
  var dynamic_block = block_scene.instance()
  dynamic_block.position.x = get_viewport_rect().size.x / 2
  dynamic_block.position.y = 200
  add_child(dynamic_block)

# ブロック落下処理
func _move_block_y():
  dynamic_block.position.y += BzLOCK_SIZE
