extends Node2D

# 定数
const CARD_WIDTH = 64
const CARD_HEIGHT = 128
const CARD_NUM = 52
const TARGET_NUM = 13

# 変数
var pair = []
var card_index_array = []

# シーン
const Card = preload("res://Card.tscn")
#const Cursor = preload("res://Cursor.tscn")

# レイヤー
onready var pyramid_card_layer = get_node("PyramidCardLayer")
onready var hand_card_layer = get_node("HandCardLayer")
onready var post_card_layer = get_node("DropCardLayer")

# 初期化
func _ready():
  # 乱数シード値
  randomize()
  # カードインデックス配列作成
  for i in range(CARD_NUM):
    card_index_array.append(i)
  # シャッフル
  card_index_array.shuffle()
  # ピラミッドのカード設定
  _set_pyramid_card()
  # 手元カードの配置
  _set_hand_card()
  
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# ピラミッド型のカード設定 
func _set_pyramid_card():
  # 配置されたカードに対して
  for card in pyramid_card_layer.get_children():
    # カードインデックス配列から先頭を取る
    var index = card_index_array.pop_front()
    # インデックス・数字の設定
    card.set_index_num(index)
    # 最下段は開いておく
    if card.get_index() > 20:
      card.flip() 

# 手札配置
func _set_hand_card():
    # カード切れ
    if card_index_array.size() < 1:
      return;
    # カード配列から１つ取る
    var index = card_index_array.pop_front()
    var card = Card.instance()
    card.position = Vector2(512, 480 + CARD_HEIGHT * 1.5)
    hand_card_layer.add_child(card)
    # インデックス・数字の設定
    card.set_index_num(index)
    # クリック可能にする
    card.set_selectable()
    
# カード選択
func add_pair(card):
  print(card.num)
