extends Node2D

# 定数
# 壁のサイズ
const TILE_SIZE = 64
# 横の壁数（奇数）
const WALL_NUM_X = 9
# 縦の壁数（奇数）
const WALL_NUM_Y = 15
# 迷路横サイズ
const MAZE_WIDTH = TILE_SIZE * WALL_NUM_X
# 迷路縦サイズ
const MAZE_HEIGHT = TILE_SIZE * WALL_NUM_Y
# 四方向ベクトル
const DIR_ARRAY = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]

# enum
enum {FLOOR, WALL}

# 変数
# 分岐点候補
var branch_array = []
# ノード
onready var tilemap = get_node("TileMap")

# 初期処理
func _ready():
  # 最初の穴掘り（奇数位置）
  var rand_pos = _get_rand_pos()
  tilemap.set_cellv(rand_pos, FLOOR)
  # 起点に穴掘り開始
  _dig(rand_pos)

# ランダムな位置を返す
func _get_rand_pos():
    var i_array = []
    var j_array = []
    
    randomize()
    # 奇数座標  
    for i in range(1, WALL_NUM_X, 2):
      i_array.append(i)
    for j in range(1, WALL_NUM_Y, 2):
      j_array.append(j)
    # 配列をシャッフル
    i_array.shuffle()
    j_array.shuffle()
    
    return Vector2(i_array.front(), j_array.front())

# 穴掘り処理
func _dig(tile_pos):
  var next_pos = tile_pos
  # 分岐点登録
  _regist_branch(tile_pos)
  # 続けて掘れるかのフラグ
  var can_dig = false
  # ランダムな順番で
  randomize()
  DIR_ARRAY.shuffle()
  
  for dir in DIR_ARRAY:
    # 2マス先
    var v2 = tile_pos + dir * 2
    # 1マス先
    var v1 = tile_pos + dir
    # 掘れる範囲なら
    if (v2.x > 0 and v2.x < WALL_NUM_X) and (v2.y > 0 and v2.y < WALL_NUM_Y):
      # 2マス先が壁か調べる
      if tilemap.get_cellv(v2) == WALL:
        # 壁なら2マス先まで掘る
        tilemap.set_cellv(v1, FLOOR)
        tilemap.set_cellv(v2, FLOOR)
        # 次の起点
        next_pos = v2
        # ループを抜ける
        can_dig = true
        break
  # 掘り進められるのであれば
  if can_dig:
    # 2マス先を開始位置にして再帰処理
    _dig(next_pos)
  else:
    # 分岐点として使えないので削除
    _delete_branch(next_pos)
    # これまでの分岐点から掘り進めるものを探す
    _search_branch()
    
# 分岐点を登録
func _regist_branch(tile_pos):
  # ダブり回避
  for pos in branch_array:
    if pos == tile_pos:
      return
  
  branch_array.append(tile_pos)

# 使えない分岐点を削除
func _delete_branch(tile_pos):
  branch_array.erase(tile_pos)

# 使える分岐点をランダムに探す
func _search_branch():
  if branch_array.size() > 0:
    randomize()
    branch_array.shuffle()
    var rand_pos = branch_array.front()
    _dig(rand_pos)
