extends Node2D

# 定数
const CARD_WIDTH = 64
const CARD_HEIGHT = 128
const CARD_NUM = 52
const TARGET_NUM = 13
const HAND_POSITION = Vector2(512, 480 + CARD_HEIGHT * 1.5)
const OPENED_POSITION = Vector2(512 - 64, 480 + CARD_HEIGHT * 1.5)
const DROP_POSITON = Vector2(128, 480 + CARD_HEIGHT * 1.5)

# 変数
var pair = []
var card_index_array = []

# シーン
const Card = preload("res://Card.tscn")
#const Cursor = preload("res://Cursor.tscn")

# レイヤー
onready var card_layer = get_node("CardLayer")

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
  for card in card_layer.get_children():
    # カードインデックス配列から先頭を取る
    var index = card_index_array.pop_front()
    # インデックス・数字の設定
    card.set_index_num(index)
    # グループに追加
    card.add_to_group("pyramids")
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
    card.position = HAND_POSITION
    card_layer.add_child(card)
    # インデックス・数字の設定
    card.set_index_num(index)
    # グループに追加
    card.add_to_group("hands")

# 手札をめくる
func open_hand_card():
  var opened_arr = get_tree().get_nodes_in_group("open_hands")
  # 開いた手札があれば
  if opened_arr.size() > 0:
    # 捨て札グループに追加
    var opened = opened_arr.front()
    opened.add_to_group("drop_hands")
    opened.remove_from_group("open_hands")
    opened.slide_to(DROP_POSITON)

  # 手札から開いた手札へ
  var hand = get_tree().get_nodes_in_group("hands").front()
  hand.add_to_group("open_hands")
  hand.remove_from_group("hands")
  hand.slide_and_flip(OPENED_POSITION)
  # 次の手札配置
  _set_hand_card()
   
# カード選択
func add_pair(card):
  # 13なら無条件で消去
  if card.num == TARGET_NUM:
    #card.disable();
    #this.flipNextCards();
    return 
  
  # １枚目
  if pair.size() == 0:
    pair.append(card)
    print(card.num)
    # 枠追加
    #Frame().addChildTo(card);
  else:
    # ２枚目
    if pair.size() == 1:
      pair.append(card)
      print(card.num)
      # ペアの数字をチェック
      #_check_pair()
