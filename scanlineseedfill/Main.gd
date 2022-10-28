extends Node2D

# 定数
const DIR_ARRAY = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]

# enum
enum {WALL, FLOOR, WATER}

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

// グローバルに展開
phina.globalize();
// アセット
var ASSETS = {
  // 画像
  image: {
    'tile': 'https://cdn.jsdelivr.net/gh/alkn203/tomapiko_run@master/assets/tile.png',
    'tile_sea': 'https://cdn.jsdelivr.net/gh/alkn203/assets_etc@master/pipo-map001_at-umi.png',
  },
};
// 定数
var UNIT = 64;
var TARGET_COLOR = 1;
/*
 * メインシーン
 */
phina.define("MainScene", {
  // 継承
  superClass: 'DisplayScene',
  // コンストラクタ
  init: function() {
    // 親クラス初期化
    this.superInit();
    
    var data = [
      [2,2,2,2,2,2,2,2,2,2],
      [2,1,1,1,1,1,1,1,1,2],
      [2,2,2,2,2,2,2,1,1,2],
      [2,1,1,1,1,1,2,1,1,2],
      [2,1,1,1,1,1,2,1,1,2],
      [2,1,1,2,1,1,2,1,1,2],
      [2,1,1,2,1,1,1,1,1,2],
      [2,1,1,2,1,1,1,1,1,2],
      [2,1,1,2,1,1,1,1,1,2],
      [2,1,1,2,1,1,1,2,2,2],
      [2,1,1,1,1,1,1,1,1,2],
      [2,1,1,1,1,2,1,1,1,2],
      [2,1,2,2,2,2,2,1,1,2],
      [2,1,1,1,1,1,1,1,1,2],
      [2,2,2,2,2,2,2,2,2,2]
    ];

    this.map = phina.util.Map({
      tileWidth: UNIT,
      tileHeight: UNIT,
      imageName: 'tile',
      mapData: data,
    }).addChildTo(this);
    
    this.waterGroup = DisplayElement().addChildTo(this);
    
    var self = this;
    // タッチ時
    this.onpointend = function(e) {
      // タッチ位置からインデックス計算
      var i = (e.pointer.x / UNIT) | 0;
      var j = (e.pointer.y / UNIT) | 0;
      // 
      if (this.map.checkTileByIndex(i, j) === TARGET_COLOR) {
        this.setInteractive(false);
        // タッチした位置から塗りつぶし開始
        this.fill(i, j);
        this.showWater();
      }
    };
  },
  // 水表示
  showWater: function() {
    this.waterGroup.children.each(function(water, i) {
      // 時間差で表示
      water.tweener.wait(100 * i)
                   .call(function() {
                     water.show();
                   }).play();
    });
  },
  // 塗りつぶし
  fill: function(i, j) {
    var map = this.map;
    var self = this;
    // シードバッファ
    this.buffer = [];
    // バッファにスタック
    this.buffer.push({ i : i, j : j });
    // バッファにシードがある限り
    while (this.buffer.length > 0) {
      // シードを１つ取り出す
      var point = this.buffer.pop();
      // 塗れる左端
      var leftI = point.i;
      // 塗れる右端
      var rightI = point.i;
      // 既に塗られていたらスキップ
      if (map.checkTileByIndex(point.i, point.j) === -1) {
        continue;
      }
      // 左端を特定
      for (; 0 < leftI; leftI--) {
        if (map.checkTileByIndex(leftI - 1, point.j) !== TARGET_COLOR) {
          break;
        }
      }
      // 右端をよ特定
      for (; rightI < 9; rightI++) {
        if (map.checkTileByIndex(rightI + 1, point.j) !== TARGET_COLOR) {
          break;
        }
      }
      // 横方向を塗る
      this.paintHorizontal(leftI, rightI, point.j);
      // 上下のラインをサーチ
      if (point.j + 1 < 14) {
        this.scanLine(leftI, rightI, point.j + 1);
      }
      if (point.j - 1 >= 0) {
        this.scanLine(leftI, rightI, point.j - 1);
      }
    }
  },
  // 指定された直線範囲を塗りつぶす
  paintHorizontal: function(leftI, rightI, j) {
    var map = this.map;
    
    for (var i = leftI; i <= rightI; i++) {
       // タイル情報更新
      map.setTileByIndex(i, j, -1);
      // 指定したインデックスの子要素を得る
      var target = map.getChildByIndex(i, j);
      // 水スプライト・一旦非表示
      var sea = Sprite('tile_sea', 32, 32).addChildTo(this.waterGroup);
      sea.setPosition(target.x, target.y);
      sea.setFrameIndex(4).hide();
      sea.setSize(64, 64);
    }
  },
  // ライン上でシードをスキャンする
  scanLine: function(leftI, rightI, j) {
    var map = this.map;
    //
    while (leftI <= rightI) {
      // 塗れる最初の場所
      for (; leftI <= rightI; leftI++) {
        if (map.checkTileByIndex(leftI, j) === TARGET_COLOR) {
            break;
        }
      }
      // 右端に到達したら終わり
      if (rightI < leftI) {
        break;
      }
      // 塗れない右端を特定
      for (; leftI <= rightI; leftI++) {
        if (map.checkTileByIndex(leftI, j) !== TARGET_COLOR) {
          break;
        }
      }
      // 塗れる右端をｓシードに登録
      this.buffer.push({ i : leftI - 1, j : j});
      // シード表示
      Label({
        text: 'S',
        fontSize: UNIT * 0.8,
      }).addChildTo(this).setPosition((leftI - 1) * UNIT + 32, j * UNIT + 32);
    }
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
