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

