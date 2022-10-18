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
    card.disable();
    #this.flipNextCards();
    return 
  
  # １枚目
  if pair.size() == 0:
    pair.append(card)
    # 枠追加
    #Frame().addChildTo(card);
  else:
    # ２枚目
    if pair.size() == 1:
      pair.append(card)
      # ペアの数字をチェック
      _check_pair()

# ペアのチェック
func _check_pair():
  var p1 = pair[0];
  var p2 = pair[1];
  # 手札と捨て札のセットは不可
  if p1.is_in_group("open_hands") and p2.is_in_group("drop_hands"):
    pair.clear()
    return
  if p1.is_in_group("drop_hands") and p1.is_in_group("open_hands"):
    pair.clear()
    return
  
  # 数字の合計が13なら取り除く
  if p1.num + p2.num == TARGET_NUM:
    p1.disable();
    p2.disable();
    # 裏返せるカードを裏返す
    yield(get_tree().create_timer(0.5), "timeout")
    _flip_next_card()
    # 捨て札の一番上のガードを選択可能にする
    #this.enableDropTop();
  else:
    pass
    # 枠削除
    #p1.children.first.remove();

  # ペア情報クリア
  pair.clear()

# 裏返せるカードを裏返す
func _flip_next_card():
  var pyramid_arr = get_tree().get_nodes_in_group("pyramids")
  # カードを総当たりチェック
  for card in pyramid_arr:
    # 選択不可（裏面）であれば
    if !card.is_in_group("selectables"):
      # 下方向にカードがあるか
      if !_is_card_blow(card):
        card.flip()

# カードの左下と右下に別のカードがあるか調べる
func _is_card_blow(card):
  var pyramid_arr = get_tree().get_nodes_in_group("pyramids")
  
  for target in pyramid_arr:
    # 左下
    if (target.position == (card.position + Vector2(-CARD_WIDTH / 2, 48))):
      return true
    # 右下
    if (target.position == (card.position + Vector2(CARD_WIDTH / 2, 48))):
      return true
      
  return false
