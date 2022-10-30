extends Node2D

# 定数
const DIR_ARRAY = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]

# 変数
# シードバッファ
var buffer = []

# enum
enum {WALL, FLOOR, WATER}

# シーン
const SeedLabel = preload("res://SeedLabel.tscn")

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
  # バッファにスタック
  buffer.append(tile_pos)
  # バッファにシードがある限り
  while buffer.size() > 0:
    # シードを１つ取り出す
    var point = buffer.pop_front()
    # 塗れる左端
    var left_x = point.x
    # 塗れる右端
    var right_x = point.x
    # 既に塗られていたらスキップ
    if tilemap.get_cellv(point) == WATER:
      continue
    # 左端を特定
    while left_x > 0:
      if tilemap.get_cellv(Vector2(left_x - 1, point.y)) != FLOOR:
        break
      left_x -= 1
    # 右端を特定
    while right_x < 9:
      if tilemap.get_cellv(Vector2(right_x + 1, point.y)) != FLOOR:
        break
      right_x += 1
    # 横方向を塗る
    _paint_horizontal(left_x, right_x, point.y)
    yield(get_tree().create_timer(0.2), "timeout")
    # 上下のラインをサーチ
    if (point.y + 1) < 14:
      _scan_line(left_x, right_x, point.y + 1)
      
    if (point.y - 1) >= 0:
      _scan_line(left_x, right_x, point.y - 1)

# 指定された直線範囲を塗りつぶす
func _paint_horizontal(left_x, right_x, y):
  for x in range(left_x, right_x + 1):
    # タイル情報更新
    tilemap.set_cellv(Vector2(x, y), WATER)
    yield(get_tree().create_timer(0.2), "timeout")
  
# ライン上でシードをスキャンする
func _scan_line(left_x, right_x, y):
    #
    while left_x <= right_x:
      # 塗れる最初の場所
      while left_x <= right_x:
        if tilemap.get_cellv(Vector2(left_x, y)) == FLOOR:
          break
        left_x += 1
      # 右端に到達したら終わり
      if right_x < left_x:
        break
      # 塗れない右端を特定
      while left_x <= right_x:
        if tilemap.get_cellv(Vector2(left_x, y)) != FLOOR:
          break
        left_x += 1
      # 塗れる右端をシードに登録
      buffer.append(Vector2(left_x - 1, y))
      # シード表示
      var seed_label = SeedLabel.instance()
      seed_label.rect_position = tilemap.map_to_world(Vector2(left_x - 1, y))
      get_node("SeedLayer").add_child(seed_label)
