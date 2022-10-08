extends Node2D

# 定数
const SCREEN_HEIGHT = 640
const GEM_SIZE = 80
const GEM_OFFSET = GEM_SIZE / 2
const GEM_NUM_X = 8
const SWAP_DURATIOM = 0.25

# 変数
var pair = []
var match_count = 0
var swap_count = 0
var second_swap = false
# シーン
const Gem = preload("res://Gem.tscn")
# レイヤー
onready var gem_layer = get_node("GemLayer")
onready var dummy_layer = get_node("DummyLayer")

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
    #var cursor1 = Cursor().addChildTo(this.cursorGroup);
    #cursor1.setPosition(gem.x, gem.y);
    pair.append(gem)
    # 隣り合わせ以外を選択不可にする
    _selectable_next()
    return

  # 二つ目
  if pair.size() == 1:
    #var cursor2 = Cursor().addChildTo(this.cursorGroup);
    #cursor2.setPosition(gem.x, gem.y);
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
    #this.cursorGroup.children.clear()

  swap_count = 2
  # 入れ替えアニメーション
  var tween1 = get_tree().create_tween()
  tween1.tween_property(g1, "position", g2.position, SWAP_DURATIOM)
  tween1.tween_callback(self, "_after_swap")

  var tween2 = get_tree().create_tween()
  tween2.tween_property(g2, "position", g1.position, SWAP_DURATIOM)
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
  else:
    # 3つ並びがあれば削除処理へ
    if _exist_match3():
      pair.clear();
      print("match3")
      #_remove_gem()
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
        if (target.position.y < gem.position.y) and (target.x == gem.x):
          target.dropCnt += 1
     
      # 消去アニメーション用ダミー作成
      var dummy = Gem.instance()
      dummy.position = Vector2(gem.x, gem.y)
      dummy.get_node("Sprite").frame = gem.get_node("Sprite").frame
      
    // ジェム削除
    this.gemGroup.children.eraseIfAll(function(gem) {
      if (gem.mark === "rmv") {
        return true;
      }
    });
    // flowで非同期処理
    var flow = Flow(function(resolve) {
      // ダミーをアニメーション
      self.dummyGroup.children.each(function(dummy) {
        dummy.tweener.clear()
                     .to({scaleX: 0.2, scaleY: 0.2, ahpha: 0.2}, 200)
                     .call(function() {
                       dummy.remove();
                       // アニメーション後
                       if (self.dummyGroup.children.length === 0) {
                         resolve('removed');
                       }
                     });
      });
    });
    
    flow.then(function(message) {
      self.dropGems();
    });
  },
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
