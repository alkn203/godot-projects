extends Node2D

# 定数
var UNIT = 64
var TARGET_INDEX = 2

# ノード
onready var tilemap = get_node("TileMap") 

# 初期化
func _ready():
  pass # Replace with function body.

# イベント取得
func _input(event):
  # マウスボタン
  if event is InputEventMouseButton:
    # クリック
    if event.pressed:
      # マウス位置取得
      var pos = event.position
      # タッチした位置から塗りつぶし開始
      if (this.map.checkTileByIndex(i, j) === TARGET_COLOR) {
        _fill(i, j) 

# 塗りつぶし処理
_fill(i, j):
  var arr = [[1, 0], [-1, 0], [0, 1], [0, -1]];
  # タイル情報更新
  map.setTileByIndex(i, j, -1)
  # 上下左右隣のタイルを調べる
    arr.each(function(elem) {
      var di = i + elem[0];
      var dj = j + elem[1];
      # 塗りつぶせる場所があれば
      if (map.checkTileByIndex(di, dj) === TARGET_COLOR) {
        # 再起呼び出し
        _fill(di, dj)
