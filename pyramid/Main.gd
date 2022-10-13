extends Node2D

# 定数
const CARD_WIDTH = 64
const CARD_HEIGHT = 128
const CARD_NUM = 52
const TARGET_NUM = 13
const DURATION = 0.25

# 変数
var pair = []
var card_index_array = []

# シーン
const Card = preload("res://Card.tscn")
const Cursor = preload("res://Cursor.tscn")

# レイヤー
onready var pyramid_card_layer = get_node("PyramidCardLayer")
onready var hand_card_layer = get_node("HandCardLayer")
onready var post_card_layer = get_node("PostCardLayer")

# 初期化
func _ready():
  # カード配置
  for i in GEM_NUM_X:
    for j in GEM_NUM_X:
      var gem = Gem.instance()
      var x = i * GEM_SIZE + GEM_OFFSET
      var y = j * GEM_SIZE + GEM_OFFSET
      gem.position = Vector2(x, y)
      gem_layer.add_child(gem)
  
  init_gem()
  
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# ジェム初期化
func init_gem():
  # 3つ並び以上があれば仕切り直し
  if _exist_match3():
    # シード値変更
    randomize()
    # 作り直し
    for gem in gem_layer.get_children():
      # ランダムな色
      var num = randi() % 7
      gem.get_node("Sprite").frame = num
      gem.num = num
      gem.mark = "normal"
      
    init_gem()
  # 画面外ジェム配置
  init_hidden_gem()

