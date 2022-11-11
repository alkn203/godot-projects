extends Sprite

# 定数
const TILE_SIZE = 64

# 変数
var tile_pos = Vector2(4, 8)

# ノード
onready var tilemap = get_node("/root/Main/Stage1/TileMap")
onready var baggage_layer = get_node("/root/Main/Stage1/BaggageLayer")

#
enum { TILE_NONE, TILE_FLOOR, TILE_GOAL, TILE_WALL, BAGGAGE, BAGGAGE_ON_GOAL } 

# 毎フレーム処理
func _process(delta):
  var v = Vector2.ZERO
  # 方向キーチェック
  if Input.is_action_just_pressed("ui_left"):
    v.x = -1
  if Input.is_action_just_pressed("ui_right"):
    v.x = 1
  if Input.is_action_just_pressed("ui_up"):
    v.y = -1
  if Input.is_action_just_pressed("ui_down"):
    v.y = 1
  # 何かしら入力があれば
  if v.x != 0 or v.y != 0:
    # その方向の一つ先の位置
    var next = tile_pos + v
    # 壁なら何もしない
    if tilemap.get_cellv(next) == TILE_WALL:
      return
    
    # 隣が荷物かどうか調べる
    var baggage = _get_baggage_by_pos(next)
    # 荷物の場合
    if baggage != null:
      # さらに荷物のその１つ先が壁
      if tilemap.get_cellv(next + v) == TILE_WALL:
        return
      # 荷物のその１つ先が荷物
      if _get_baggage_by_pos(next + v) != null:
        return
      
      # 荷物位置更新
      baggage.tile_pos += v
      baggage.position += v * TILE_SIZE
      # 荷物がゴールに乗っているかのチェック
      _change_baggage_color_on_goal()
      # クリアチェック
      if _is_clear() == true:
        OS.alert("clear")
			
      # プレイヤー位置更新
      tile_pos = next
      position += v * TILE_SIZE

# 指定位置の荷物を返す
func _get_baggage_by_pos(pos):
  for baggage in baggage_layer.get_children():
    if baggage.tile_pos == pos:
      return baggage
  # 荷物がない場合
  return null

# ゴールに乗っている荷物の色を変える 
func _change_baggage_color_on_goal():
  for baggage in baggage_layer.get_children(): 
    if tilemap.get_cellv(baggage.tile_pos) == TILE_GOAL: 
      baggage.frame = BAGGAGE_ON_GOAL
    else:
      baggage.frame = BAGGAGE

# クリアチェック 
func _is_clear(): 
  for baggage in baggage_layer.get_children():
    if baggage.frame == BAGGAGE:
      return false
  return true
