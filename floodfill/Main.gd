extends Node2D


# Declare member variables here. Examples:
onready var screen_size = get_viewport_rect().size
onready var ufo_scene = preload("res://Ufo.tscn")
onready var ufo_layer = find_node("UfoLayer")
onready var ufo_timer = find_node("UfoTimer") 


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#
	if ufo_timer.is_stopped():
		var ufo = ufo_scene.instance()
		ufo.position = Vector2(screen_size.x, 64)
		ufo_layer.add_child(ufo)
		ufo_timer.start()

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
