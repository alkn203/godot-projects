extends Node2D

# 定数
const CARD_WIDTH = 64
const CARD_HEIGHT = 128
const CARD_NUM = 52
const TARGET_NUM = 13
const HAND_POSITION = Vector2(512, 480 + CARD_HEIGHT * 1.5)
const OPENED_POSITION = Vector2(512 - 64, 480 + CARD_HEIGHT * 1.5)
const DROP_POSITON = Vector2(128, 480 + CARD_HEIGHT * 1.5)
const DURATION = 0.15

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
    card.add_to_group("pyramid")
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
  card.add_to_group("hand")

# 手札をめくる
func open_hand_card():
  var opened_arr = get_tree().get_nodes_in_group("open_hand")
  # 開いた手札があれば
  if opened_arr.size() > 0:
    # 捨て札グループに追加
    var opened = opened_arr.front()
    opened.add_to_group("drop_hand")
    opened.remove_from_group("open_hand")
    opened.slide_to(DROP_POSITON)

  # 手札から開いた手札へ
  var hand = get_tree().get_nodes_in_group("hands").front()
  hand.add_to_group("open_hand")
  hand.remove_from_group("hand")
  hand.slide_and_flip(OPENED_POSITION)
  # 次の手札配置
  _set_hand_card()
   
# カード選択
func add_pair(card):
  # 13なら無条件で消去
  if card.num == TARGET_NUM:
    card.disable();
    # 裏返せるカードを裏返す
    _wait_time(DURATION)
    _flip_next_card()
    _selectable_drop_top()
    return 
  
  # １枚目
  if pair.size() < 1:
    pair.append(card)
    # 枠追加
    #Frame().addChildTo(card);
  else:
    # ２枚目
    if pair.size() < 2:
      pair.append(card)
      # ペアの数字をチェック
      _check_pair()

# ペアのチェック
func _check_pair():
  var p1 = pair[0];
  var p2 = pair[1];
  # 手札と捨て札のセットは不可
  if p1.is_in_group("open_hand") and p2.is_in_group("drop_hand"):
    pair.clear()
    return
  if p1.is_in_group("drop_hand") and p1.is_in_group("open_hand"):
    pair.clear()
    return
  
  # 数字の合計が13なら
  if p1.num + p2.num == TARGET_NUM:
    # ペアを削除
    _disable_pair()
    # 捨て札の一番上だけを選択可能にする
    _selectable_drop_top()
  else:
    pass
    # 枠削除
    #p1.children.first.remove();

  # ペア情報クリア
  pair.clear()

# 裏返せるカードを裏返す
func _flip_next_card():
  var pyramid_arr = get_tree().get_nodes_in_group("pyramid")
  # カードを総当たりチェック
  for card in pyramid_arr:
    # 選択不可（裏面）であれば
    if !card.is_in_group("selectable"):
      # 下方向にカードがなければ裏返す
      if !_is_card_blow(card):
        card.flip()

# カードの左下と右下に別のカードがあるか調べる
func _is_card_blow(card):
  var pyramid_arr = get_tree().get_nodes_in_group("pyramid")
  for target in pyramid_arr:
    # 左下
    if (target.position == (card.position + Vector2(-CARD_WIDTH / 2, 48))):
      return true
    # 右下
    if (target.position == (card.position + Vector2(CARD_WIDTH / 2, 48))):
      return true
      
  return false

# 捨て札の１番上だけを選択可能にする
func selectable_drop_top():
  var drop_arr = get_tree().get_nodes_in_group("drop")
  # 一旦全て選択不可に
  for card in drop_arr:
    card.remove_from_group("selectable")

  # 最後の要素だけ選択可能にする
  var last = drop_arr.back()
  if last:
    last.add_to_group("selectable")

# ペアを削除
func _disable_pair():
  # アニメーション：縮小して削除
  var tween = get_tree().create_tween()
  tween.set_paralel(true)

  for card in pair:
    tween.tween_property(card, "scale", Vector2(), DURATION)

  tween.set_paralel(false)

  for card in pair:
    tween.tween_callback(card, "queue_free")
 
  tween.tween_callback(self, "_flip_next_card")
