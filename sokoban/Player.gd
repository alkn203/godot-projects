extends Sprite

# 定数
const TILE_SIZE = 64
const DURATION = 0.25
const KEY_ARRAY = [
    ["ui_down", Vector2(0, 1)],
    ["ui_up", Vector2(0, -1)],
    ["ui_left", Vector2(-1, 0)],
    ["ui_right", Vector2(1, 0)]]
# 変数
var tile_pos = Vector2(4, 8)
var can_input = true

# ノード
onready var stage = get_node("/root/Main/Stage1")
onready var tilemap = get_node("/root/Main/Stage1/TileMap")
onready var baggage_layer = get_node("/root/Main/Stage1/BaggageLayer")

# タイル情報
enum { TILE_NONE, TILE_FLOOR, TILE_GOAL, TILE_WALL, BAGGAGE, BAGGAGE_ON_GOAL } 

# 毎フレーム処理
func _process(delta):
  # キー入力不可の場合
  if can_input == false:
    return
      
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
    # tween作成
    var tween = get_tree().create_tween()
    # その方向の一つ先の位置
    var next = tile_pos + v
    # 壁なら何もしない
    if tilemap.get_cellv(next) == TILE_WALL:
      return
    
    # 隣が荷物かどうか調べる
    var baggage = stage.get_baggage_by_pos(next)
    # 荷物の場合
    if baggage != null:
      # さらに荷物のその１つ先が壁
      if tilemap.get_cellv(next + v) == TILE_WALL:
        return
      # 荷物のその１つ先が荷物
      if stage.get_baggage_by_pos(next + v) != null:
        return
      
      # 荷物位置更新
      baggage.tile_pos += v
      tween.set_parallel(true)
      tween.tween_property(baggage, "position", baggage.position + v * TILE_SIZE, DURATION)
      
    # プレイヤー位置更新
    tile_pos = next
    # 一旦入力不可にする
    can_input = false
    # 移動アニメーション
    tween.tween_property(self, "position", position + v * TILE_SIZE, DURATION)
    tween.set_parallel(false)
    tween.tween_callback(self, "_after_move")

func _after_move():
  can_input = true
  # 荷物がゴールに乗っているかのチェック
  stage.change_baggage_color_on_goal()
  # クリアチェック
  if stage.is_clear() == true:
    OS.alert("clear")

