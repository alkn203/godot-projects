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
  # 乱数シード値
  randomize()
  # カードインデックス配列
  for i in range(CARD_NUM):
    card_index_array.append(i)
  # シャッフル
  card_index_array.shuffle()
  # カード設定
  _set_pytamid_card()
  
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# ピラミッド型のカード設定 
func _set_pytamid_card():
  # 
  for card in pyramid_card_layer.get_children():
      #
      var i = card.get_index()
      #
      var index = card_index_array.pop_front()
      #
      card.set_index_num(index)
      #
      if i > 20:
        card.flip() 
