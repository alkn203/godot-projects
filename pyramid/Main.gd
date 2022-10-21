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
var flip_count = 0
var remove_count = 0

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
      _flip_card(card) 

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
    _remove_card(card)
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
    for card in pair:
      _remove_card(card)
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
        _flip_card(card)

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

# カード返し処理
func _flip_card(card):
  flip_count += 1
  var tween = get_tree().create_tween()
  # 縮小 
  tween.tween_property(card, "scale", Vector2(0.1, 1.0), DURATION)
  # 絵柄セット
  tween.tween_callback(card, "_set_frame_index")
  # 拡大
  tween.tween_property(card, "scale", Vector2(1.0, 1.0), DURATION)
  # 選択可能グループに追加
  tween.tween_callback(card, "add_to_group", ["selectable"])
  # 後処理に繋ぐ
  tween.tween_callback(self, "_after_flip")

# カード返し処理後
func _after_flip():
  flip_count -= 1
  # カードが開ききってから次の処理
  if flip_count == 0:
    # 捨て札の一番上だけ選択可能にする
    _selectable_drop_top()

# カード削除処理
func _remove_card(card):
  remove_count += 1
  var tween = get_tree().create_tween()
  # 縮小
  tween.tween_property(card, "scale", Vector2(), DURATION)
  # 削除
  tween.tween_callback(card_layer, "remove_child", [card])
  # 後処理に繋ぐ
  tween.tween_callback(self, "_after_remove")

# カード削除処理後
func _after_remove():
  remove_count -= 1
  # カードが削除されきってから次の処理
  if remove_count == 0:
    # 次に開けるカードがあるかチェック
    _flip_next_card()
