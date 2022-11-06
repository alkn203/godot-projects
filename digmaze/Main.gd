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
  #_dig(rand_pos)

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
  #_regist_branch(tile_pos)
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
#    if (canDig) {
#      // 2マス先を開始位置にして再帰処理
#      this.dig(nextI, nextJ);
#   }
#    else {
#      // 分岐点として使えないので削除
#      this.deleteBranch(nextI, nextJ);
#      // これまでの分岐点から掘り進めるものを探す
#      this.searchBranch();
#    }
#  },
#  // 分岐点を登録
#  registBranch: function(indexI, indexJ) {
#    // ダブり回避
#    var result = this.branches.some(function(branch) {
#      return (branch.i === indexI && branch.j === indexJ);
#    });
#
#    if (!result) {
#      this.branches.push({i: indexI, j: indexJ});
#    }
#  },
#  // 使えない分岐点を削除
#  deleteBranch: function(indexI, indexJ) {
#    this.branches.eraseIfAll(function(branch) {
#      return (branch.i === indexI && branch.j === indexJ);
#    });
#  },
#  // 使える分岐点を探す
#  searchBranch: function() {
#    if (this.branches.length > 0) {
#      var rand = this.branches.random();
#      this.dig(rand.i, rand.j);
#    }
#  },
