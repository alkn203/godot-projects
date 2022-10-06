extends Node2D

# 定数
const GEM_SIZE = 80
const GEM_OFFSET = GEM_SIZE / 2
const GEM_NUM_X = 8

# 変数
# ペア格納用配列
var pair = []
# シーン
const Gem = preload("res://Gem.tscn")
# レイヤー
onready var gem_layer = get_node("GemLayer")

# Called when the node enters the scene tree for the first time.
func _ready():
        # ジェム配置
	for i in GEM_NUM_X:
		for j in GEM_NUM_X:
			var gem = Gem.instance()
			gem.position = Vector2(i * GEM_SIZE, j * GEM_SIZE) + Vector2(GEM_OFFSET, GEM_OFFSET)
			gem_layer.add_child(gem)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# ジェム初期化
func init_gem():
    # 3つ並び以上があれば仕切り直し
    if exist_match3():
      # シード値変更
      randomize()
      # 作り直し
      for gem in gem_layer.get_child():
        # ランダムな色
        gem.get_node("Sprite").frame = randi() % 7;
        gem.mark = "normal"
      
      init_gem()

    # 画面外ジェム配置
    init_hidden_gem()

# 画面外のジェム配置
func init_hidden_gem():
    # 一旦消す
    for gem in gem_layer.get_child():
      if gem.position.y < 0:
        gem.queue_free()
    
    # ジェム配置
    for i in GEM_NUM_X:
	for j in GEM_NUM_X:
		var gem = Gem.instance()
		gem.position = Vector2(i * GEM_SIZE, j * GEM_SIZE) + Vector2(GEM_OFFSET, GEM_OFFSET)
                # 画面分上にずらす
                gem.position -= Vector2(0, SCREEN_HEIGHT)
		gem_layer.add_child(gem)

# ペア選択処理
func select_pair(gem):
	print(gem.name)

# 3つ並び以上存在チェック
func _exist_match3():
    for gem in gem_layer.get_child():
      # 画面に見えているジェムのみ
      if gem.y > 0:
        # 横方向
        _check_horizontal(gem)
        _set_mark()
        # 縦方向
        _check_vertical(gem)
        _set_mark();

    for gem in gem_layer.get_child():
      # 削除対象があれば
      if gem.mark == "rmv":
        return true
    
    return false

# 横方向の3つ並び以上チェック
func _check_horizontal(current):
    if current.mark != "rmv":
      current.mark = "tmp"

    match_count += 1
    var next = _get_gem(current.position + Vector2(GRID_SIZE, 0))
    if (next and current.num == next.num:
      _check_horizontal(next)

# 縦方向の3つ並び以上チェック
func _check_vertical(current):
    if current.mark != "rmv":
      current.mark = "tmp"

    match_count += 1
    var next = _get_gem(current.position + Vector2(0, GRID_SIZE))
    if (next and current.num == next.num:
      _check_vertical(next)

# マークセット
func setMark():
    for gem in gem_layer.get_child():
      if gem.mark == "tmp":
        # 3つ並び以上なら削除マーク
        if match_count > 2:
          gem.mark = "rmv"
        else:
          gem.mark = "normal"
    
    match_count = 0
