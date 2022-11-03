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

# ノード
onready var tilemap = get_node("TileMap") 

# イベント取得
func _input(event):
  # マウスボタン
  if event is InputEventMouseButton:
    # クリック
    if event.pressed:
      # マウス位置をタイル位置に変換
      var pos = event.position
      var tile_pos = tilemap.world_to_map(pos)
      # タッチした位置が床なら塗りつぶし開始
      if tilemap.get_cellv(tile_pos) == FLOOR:
        _fill(tile_pos) 

# 塗りつぶし処理
func _fill(tile_pos):
  # 時間差で段階的に塗る
  yield(get_tree().create_timer(0.2), "timeout")
  # タイル情報更新
  tilemap.set_cellv(tile_pos, WATER)
  # 上下左右隣のタイルを調べる
  for dir in DIR_ARRAY:
    var next_pos = tile_pos + dir
    # 塗りつぶせる場所があれば
    if tilemap.get_cellv(next_pos) == FLOOR:
      # 再起呼び出し
      _fill(next_pos)

#    // 分岐点候補
#    this.branches = [];
#       // 最初の穴掘り（奇数位置）
#    var randI = Array.range(1, WALL_NUM_X, 2).random();
#    var randJ = Array.range(1, WALL_NUM_Y, 2).random();
#    this.map.setTileByIndex(randI, randJ, FLOOR);
#    // 起点に穴掘り開始
#    this.dig(randI, randJ);
#  },
#  // 穴掘り処理
#  dig: function(i, j) {
#
#    var map = this.map;
#    var self = this;
#
#    var nextI = i;
#    var nextJ = j;
#    // 分岐点登録
#    this.registBranch(i, j);
#    // ランダムな順番で
#    var canDig = DIR_ARRAY.shuffle().some(function(direction) {
#      var i2 = i + direction.x * 2;
#      var j2 = j + direction.y * 2;
#      // 掘れる範囲なら
#      if ((i2 > 0 && i2 < WALL_NUM_X) && (j2 > 0 && j2 < WALL_NUM_Y)) {
#        // 2マス先が壁か調べる
#        if (map.checkTileByIndex(i2, j2) === WALL) {
#          // 壁なら2マス先まで掘る
#          map.setTileByIndex(i + direction.x, j + direction.y, FLOOR);
#          map.setTileByIndex(i2, j2, FLOOR);
#          // 次の起点
#          nextI = i2;
#          nextJ = j2;
#          return true;
#        }
#      }
#    });
#    // 掘り進められるのであれば
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
#});
#// メイン
#phina.main(function() {
#  var app = GameApp({
#    startLabel: 'main',
#    width: MAZE_WIDTH,
#    height: MAZE_HEIGHT,
#    assets: ASSETS,
#  });
#  app.run();
#});
