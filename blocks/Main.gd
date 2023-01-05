extends Node2D


# 定数
const BLOCK_SIZE = 40
const BLOCK_COLS = 10
const BLOCK_ROWS = 20
const BLOCK_ALL_WIDTH = BLOCK_SIZE * BLOCK_COLS
const BLOCK_ALL_HEIGHT = BLOCK_ALL_WIDTH * 2
#var INTERVAL = 20

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
  var type = 4
  # ブロック作成
  var block_scene = load("res://Block" + str(type) + ".tscn")
  var dynamic_block = block_scene.instance()
  dynamic_block.position.x = get_viewport_rect().size.x / 2
  dynamic_block.position.y = 200
  add_child(dynamic_block)
