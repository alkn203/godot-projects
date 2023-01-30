extends Node2D

# 定数
const SCREEN_HEIGHT = 640
const GEM_SIZE = 80
const GEM_OFFSET = GEM_SIZE / 2
const GEM_NUM_X = 8
const GEM_NUM = GEM_NUM_X * GEM_NUM
const GEM_COLOR = 7
const DURATION = 0.25

# 変数
var pair: Array = []
var match_count: int = 0
var second_swap: bool = false

# シーン
const gem_scene = preload("res://Gem.tscn")
const cursor_scene = preload("res://Cursor.tscn")

# レイヤー
onready var gem_layer: CanvasLayer = get_node("GemLayer")
onready var dummy_layer: CanvasLayer = get_node("DummyLayer")
onready var cursor_layer: CanvasLayer = get_node("CursorLayer")

# 初期化処理
func _ready() -> void:
  # ジェム作成
  _create_gem()
  # ジェム初期化
  _init_gem()
  # 画面外ジェム配置
  _init_hidden_gem()
  # インデックス位置更新
  _update_index_pos()

# ジェム作成処理
func _create_gem(type: string = "") -> void:
  # シード値変更
  randomize()
  # ジェム配置
  for i in GEM_NUM:
    # グリッドのインデックス位置
    var x_index = i % GEM_NUM_X
    var y_index = int(i / GEM_NUM_X)
    # ジェム作成
    var gem = gem_scene.instance()
    gem.position.x = x_index * GEM_SIZE + GEM_OFFSET
    gem.position.y = y_index * GEM_SIZE + GEM_OFFSET
    # 画面外の場合
    if type == "hidden":
        gem.position.y -= SCREEN_HEIGHT

    gem_layer.add_child(gem)
    # ランダムな色設定
    gem.set_random_color(GEM_COLOR)

# ジェム初期化処理
func _init_gem() -> void:
  # 3つ並び以上があれば仕切り直し
  if _exist_match3():
    # シード値変更
    randomize()
    # 色作り直し
    for gem in gem_layer.get_children():
      # ランダムな色
      gem.set_random_color(GEM_COLOR)

    # 再帰呼び出し  
    _init_gem()

# 画面外のジェム配置
func _init_hidden_gem() -> void:
  # 一旦消す
  for gem in gem_layer.get_children():
    if gem.position.y < 0:
      gem.queue_free()

  # ジェム配置
  _create_gem("hidden")

# ペア選択処理
func select_pair(gem) -> void:
  # 一つ目
  if pair.size() == 0:
    # カーソル表示
    var cursor1: Cursor = cursor_scene.instance()
    cursor1.position = gem.position
    cursor_layer.add_child(cursor1)
    pair.append(gem)
    # 隣り合わせ以外を選択不可にする
    _selectable_next()
    return

  # 二つ目
  if pair.size() == 1:
    var cursor2: Cursor = cursor_scene.instance()
    cursor2.position = gem.position
    cursor_layer.add_child(cursor2)
    pair.append(gem)
    # 入れ替え処理
    _swap_gem()

# 隣り合わせ以外を選択不可にする
func _selectable_next() -> void:
    # 一旦全てを選択不可に
    for gem in gem_layer.get_children():
      gem.get_node("CollisionShape2D").set_deferred("disabled", true)
    
    var gem: Gem = pair[0]

    for target in gem_layer.get_children():
      var dx: float = abs(gem.index_pos.x - target.index_pos.x)
      var dy: float = abs(gem.index_pos.y - target.index_pos.y)
      # 上下左右隣り合わせだけを選択可に
      if gem.index_pos.x == target.index_pos.x and dy == 1:
        target.get_node("CollisionShape2D").set_deferred("disabled", false)
      if gem.index_pos.y == target.index_pos.y and dx == 1:
        target.get_node("CollisionShape2D").set_deferred("disabled", false)

# ジェム入れ替え処理
func _swap_gem() -> void:
  var g1: Gem = pair[0]
  var g2: Gem = pair[1]
  # 1回目
  if !second_swap:
    _set_gem_collision_disble(true)

  # 入れ替えアニメーション
  var tween: SceneTreeTween = get_tree().create_tween()
  # 並行処理
  tween.set_parallel(true)
  tween.tween_property(g1, "position", g2.position, DURATION)
  tween.tween_property(g2, "position", g1.position, DURATION)
  # 並行処理解除
  tween.set_parallel(false)
  tween.tween_callback(self, "_after_swap")

# 入れ替え後処理
func _after_swap() -> void:
  # 戻りの入れ替えなら
  if second_swap:
    pair.clear();
    _set_gem_collision_disble(false)
    second_swap = false
    # カーソル削除 
    _remove_cursor()
  else:
    # インデックス位置更新
    _update_index_pos()
    # 3つ並びがあれば削除処理へ
    if _exist_match3():
      pair.clear();
      _remove_cursor()
      _remove_gem()
    else:
      # 戻りの入れ替え
      second_swap = true
      _swap_gem()

# カーソル削除
func _remove_cursor() -> void:
  for cursor in cursor_layer.get_children():
    cursor_layer.remove_child(cursor)
    cursor.queue_free()
  
# 3つ並び以上存在チェック
func _exist_match3() -> bool:
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
func _check_horizontal(current) -> void:
  if current.mark != "rmv":
    current.mark = "tmp"
    
  match_count += 1
  var next = _get_gem(current.index_pos + Vector2.RIGHT)
  if (next != null) and (current.num == next.num):
    _check_horizontal(next)

# 縦方向の3つ並び以上チェック
func _check_vertical(current) -> void:
  if current.mark != "rmv":
    current.mark = "tmp"
    
  match_count += 1
  var next = _get_gem(current.index_pos + Vector2.DOWN)
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
      var dummy = gem_scene.instance()
      dummy.position = gem.position
      dummy.get_node("Sprite").frame = gem.get_node("Sprite").frame
      dummy_layer.add_child(dummy)
      
  # ジェム削除
  for gem in gem_layer.get_children():
    if gem.mark == "rmv":
      gem_layer.remove_child(gem)
      gem.queue_free()
        
  # ダミーをアニメーション
  var tween: SceneTreeTween = get_tree().create_tween()
  tween.set_parallel(true)

  for dummy in dummy_layer.get_children():
    tween.tween_property(dummy, "scale", Vector2(), DURATION)

  tween.set_parallel(false)
  tween.tween_callback(self, "_after_remove")
  
# 削除後の処理
func _after_remove() -> void:
  # ダミーを削除
  for dummy in dummy_layer.get_children():
    dummy_layer.remove_child(dummy)
    dummy.queue_free()
  # ジェムを落下させる
  _drop_gem()
  
# ジェムの落下処理
func _drop_gem() -> void:
  var tween: SceneTreeTween = get_tree().create_tween()
  tween.set_parallel(true)
  
  for gem in gem_layer.get_children():
    # 落下フラグがあるジェムを落下させる
    if gem.drop_count > 0:
      # 移動先座標
      var x = gem.position.x
      var y = gem.position.y + gem.drop_count * GEM_SIZE
      var d = gem.drop_count * DURATION
      # 落下アニメーション
      tween.tween_property(gem, "position", Vector2(x, y), d).set_trans(Tween.TRANS_CUBIC)
      #tween.set_ease(Tween.EASE_OUT)
  
  tween.set_parallel(false)
  tween.tween_callback(self, "_after_drop")

func _after_drop() -> void:
  # ジェムの落下フラグリセット
  for gem in gem_layer.get_children():
    gem.drop_count = 0
  # 画面外のジェムを作り直す
  _init_hidden_gem()
  # インデックス位置更新
  _update_index_pos()
  # 3並び再チェック
  if _exist_match3():
    # 連鎖削除
    _remove_gem()
  else:
    _set_gem_collision_disble(false)
    
# Gemの選択可不可を決定
func _set_gem_collision_disble(b) -> void:
  for gem in gem_layer.get_children():
    gem.get_node("CollisionShape2D").set_deferred("disabled", b)
  
# 指定されたインデックス位置のジェムを返す
func _get_gem(pos):
  # 該当するジェムがあったらループを抜ける
  for gem in gem_layer.get_children():
    if gem.index_pos == pos:
      return gem
  return null

# インデックス位置更新
func _update_index_pos:() -> void:
  for gem in gem_layer.get_children():
    var i = int(gem.position.x / GEM_SIZE)
    var j = int(gem.position.y / GEM_SIZE)
    gem.index_pos = Vector2(i, j)
