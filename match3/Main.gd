extends Node2D

# 定数
const SCREEN_HEIGHT = 640
const GEM_SIZE = 80
const GEM_OFFSET = GEM_SIZE / 2
const GEM_NUM_X = 8
const DURATION = 0.25

# 変数
var pair = []
var match_count = 0
var swap_count = 0
var second_swap = false
var remove_count = 0
var drop_count = 0
# シーン
const Gem = preload("res://Gem.tscn")
const Cursor = preload("res://Cursor.tscn")
# レイヤー
onready var gem_layer = get_node("GemLayer")
onready var dummy_layer = get_node("DummyLayer")
onready var cursor_layer = get_node("CursorLayer")

# Called when the node enters the scene tree for the first time.
func _ready():
  # ジェム配置
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

# 画面外のジェム配置
func init_hidden_gem():
  # 一旦消す
  for gem in gem_layer.get_children():
    if gem.position.y < 0:
      gem.queue_free()
      
  # シード値変更
  randomize()
  # ジェム配置
  for i in GEM_NUM_X:
    for j in GEM_NUM_X:
      var gem = Gem.instance()
      var x = i * GEM_SIZE + GEM_OFFSET
      var y = j * GEM_SIZE + GEM_OFFSET
      gem.position = Vector2(x, y)
      # 画面分上にずらす
      gem.position.y -= SCREEN_HEIGHT
      gem_layer.add_child(gem)
      # ランダムな色
      var num = randi() % 7
      gem.get_node("Sprite").frame = num
      gem.num = num
      gem.mark = "normal"

# ペア選択処理
func select_pair(gem):
  # 一つ目
  if pair.size() == 0:
    # カーソル表示
    var cursor1 = Cursor.instance()
    cursor1.position = gem.position
    cursor_layer.add_child(cursor1)
    pair.append(gem)
    # 隣り合わせ以外を選択不可にする
    _selectable_next()
    return

  # 二つ目
  if pair.size() == 1:
    var cursor2 = Cursor.instance()
    cursor2.position = gem.position
    cursor_layer.add_child(cursor2)
    pair.append(gem)
    # 入れ替え処理
    _swap_gem()

# 隣り合わせ以外を選択不可にする
func _selectable_next():
    # 一旦全てを選択不可に
    for gem in gem_layer.get_children():
      gem.get_node("CollisionShape2D").set_deferred("disabled", true)
    
    var gem = pair[0]
    for target in gem_layer.get_children():
      var dx = abs(gem.position.x - target.position.x)
      var dy = abs(gem.position.y - target.position.y)
      # 上下左右隣り合わせだけを選択可に
      if gem.position.x == target.position.x and dy == GEM_SIZE:
        target.get_node("CollisionShape2D").set_deferred("disabled", false)
      if gem.position.y == target.position.y and dx == GEM_SIZE:
        target.get_node("CollisionShape2D").set_deferred("disabled", false)

# ジェム入れ替え処理
func _swap_gem():
  var g1 = pair[0]
  var g2 = pair[1]
  # 1回目
  if !second_swap:
    _set_gem_collision_disble(true)

  swap_count = 2
  # 入れ替えアニメーション
  var tween1 = get_tree().create_tween()
  tween1.tween_property(g1, "position", g2.position, DURATION)
  tween1.tween_callback(self, "_after_swap")

  var tween2 = get_tree().create_tween()
  tween2.tween_property(g2, "position", g1.position, DURATION)
  tween2.tween_callback(self, "_after_swap")

func _after_swap():
  # 確実に入れ替えが行われた後に実行
  swap_count -= 1
  if swap_count > 0:
    return

  # 入れ替え後処理
  if second_swap:
    pair.clear();
    _set_gem_collision_disble(false)
    second_swap = false
    
    for cursor in cursor_layer.get_children():
      cursor.queue_free()

  else:
    # 3つ並びがあれば削除処理へ
    if _exist_match3():
      pair.clear();
      _remove_gem()

      for cursor in cursor_layer.get_children():
        cursor.queue_free()
    else:
      # 戻りの入れ替え
      second_swap = true
      _swap_gem()

# 3つ並び以上存在チェック
func _exist_match3():
  for gem in gem_layer.get_children():
    # 画面に見えているジェムのみ
    if gem.position.y > 0:
      # 横方向
      _check_horizontal(gem)
      _set_mark()
      # 縦方向
      _check_vertical(gem)
      _set_mark();
  
  for gem in gem_layer.get_children():
    # 削除対象があれば
    if gem.mark == "rmv":
      return true
  
  return false

# 横方向の3つ並び以上チェック
func _check_horizontal(current):
  if current.mark != "rmv":
    current.mark = "tmp"
    
  match_count += 1
  var next = _get_gem(current.position + Vector2(GEM_SIZE, 0))
  if (next != null) and (current.num == next.num):
    _check_horizontal(next)

# 縦方向の3つ並び以上チェック
func _check_vertical(current):
  if current.mark != "rmv":
    current.mark = "tmp"
    
  match_count += 1
  var next = _get_gem(current.position + Vector2(0, GEM_SIZE))
  if (next != null) and (current.num == next.num):
    _check_vertical(next)

# マークセット
func _set_mark():
  for gem in gem_layer.get_children():
    if gem.mark == "tmp":
      # 3つ並び以上なら削除マーク
      if match_count > 2:
        gem.mark = "rmv"
      else:
        gem.mark = "normal"
  
  match_count = 0

# ジェムの削除処理
func _remove_gem():
  for gem in gem_layer.get_children():
    if gem.mark == "rmv":
      # 削除対象ジェムより上にあるジェムに落下回数をセット
      for target in gem_layer.get_children():
        if (target.position.y < gem.position.y) and (target.position.x == gem.position.x):
          target.drop_count += 1
     
      # 消去アニメーション用ダミー作成
      var dummy = Gem.instance()
      dummy.position = gem.position
      dummy.get_node("Sprite").frame = gem.get_node("Sprite").frame
      dummy_layer.add_child(dummy)
      
  # ジェム削除
  for gem in gem_layer.get_children():
    if gem.mark == "rmv":
      gem.queue_free()
      remove_count += 1
        
  # ダミーをアニメーション
  for dummy in dummy_layer.get_children():
    var tween = get_tree().create_tween()
    tween.tween_property(dummy, "scale", Vector2(), DURATION)
    tween.tween_callback(dummy, "queue_free")
    tween.tween_callback(self, "_after_remove")

# 削除後の処理
func _after_remove():
  # 削除対象の全てのジェムが削除されてから
  remove_count -= 1
  if remove_count > 0:
    return
  # ジェムを落下させる
  _drop_gem()
  
# ジェムの落下処理
func _drop_gem():
  for gem in gem_layer.get_children():
    # 落下フラグがあるジェムを落下させる
    if gem.drop_count > 0:
      # 落下ジェム数カウント
      drop_count += 1
      # 移動先座標
      var x = gem.position.x
      var y = gem.position.y + gem.drop_count * GEM_SIZE
      var d = gem.drop_count * DURATION
      # 落下アニメーション
      var tween = get_tree().create_tween()
      tween.tween_property(gem, "position", Vector2(x, y), d)
      tween.tween_callback(self, "_after_drop")

func _after_drop():
  # 落下対象の全てのジェムが確実に落ちてから
  drop_count -= 1
  if drop_count > 0:
    return
  # ジェムの落下プラグリセット
  for gem in gem_layer.get_children():
    gem.drop_count = 0
    
  # 画面外のジェムを作り直す
  init_hidden_gem()
  # 3並び再チェック
  if _exist_match3():
    # 連鎖削除
    _remove_gem()
  else:
    _set_gem_collision_disble(false)
    
# Gemの選択可不可を決定
func _set_gem_collision_disble(b):
  for gem in gem_layer.get_children():
    gem.get_node("CollisionShape2D").set_deferred("disabled", b)
  
# 指定された位置のジェムを返す
func _get_gem(pos):
  # 該当するジェムがあったらループを抜ける
  for gem in gem_layer.get_children():
    if gem.position == pos:
      return gem
  return null
