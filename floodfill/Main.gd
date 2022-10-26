extends Node2D

# 定数
var UNIT = 64
var TARGET_INDEX = 2

# ノード
onready var tilemap = get_node("TileMap") 

# 初期化
func _ready():
  pass # Replace with function body.

# 毎フレーム処理
func _process(delta):
  # タッチ位置取得
  
  if (this.map.checkTileByIndex(i, j) === TARGET_COLOR) {
    # タッチした位置から塗りつぶし開始
    _fill(i, j)

# 塗りつぶし処理
_fill(i, j):
    var map = this.map;
    var arr = [[1, 0], [-1, 0], [0, 1], [0, -1]];
    var self = this;
    // タイル情報更新
    map.setTileByIndex(i, j, -1);
    // 指定したインデックスの子要素を得る
    var target = this.map.getChildByIndex(i, j);
    // 水スプライト・一旦非表示
    var sea = Sprite('tile_sea', 32, 32).addChildTo(this.waterGroup).setPosition(target.x, target.y);
    sea.setFrameIndex(4).hide();
    sea.setSize(64, 64);
    // 上下左右隣のタイルを調べる
    arr.each(function(elem) {
      var di = i + elem[0];
      var dj = j + elem[1];
      // 塗りつぶせる場所があれば
      if (map.checkTileByIndex(di, dj) === TARGET_COLOR) {
        // 再起呼び出し
        self.fill(di, dj);
      }
    });
  },
});
/*
 * メイン処理
 */
phina.main(function() {
  // アプリケーションを生成
  var app = GameApp({
    // MainScene から開始
    startLabel: 'main',
    // アセット読み込み
    assets: ASSETS,
  });
  // fps表示
  //app.enableStats();
  // 実行
  app.run();
});
