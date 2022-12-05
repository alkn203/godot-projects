extends Node2D

# 定数
const TILE_SIZE = 64
const BAGGAGE_POS = [Vector2(4, 7), Vector2(4, 6)]

# ノード
onready var tilemap: TileMap = get_node("TileMap")
onready var baggage_layer: CanvasLayer = get_node("BaggageLayer")

# シーン
onready var baggage_scene = preload("res://Baggage.tscn")

# タイル情報
enum { TILE_NONE, TILE_FLOOR, TILE_GOAL, TILE_WALL, BAGGAGE, BAGGAGE_ON_GOAL } 

# 初期化処理
func _ready() -> void:
  # 荷物配置
  for pos in BAGGAGE_POS:
    var baggage: Baggage = baggage_scene.instance()
    baggage.tile_pos = pos
    baggage.position = pos * TILE_SIZE
    baggage_layer.add_child(baggage)

# 指定位置の荷物を返す
func get_baggage_by_pos(pos):
  for baggage in baggage_layer.get_children():
    if baggage.tile_pos == pos:
      return baggage
  # 荷物がない場合
  return null

# ゴールに乗っている荷物の色を変える 
func change_baggage_color_on_goal() -> void:
  for baggage in baggage_layer.get_children(): 
    if tilemap.get_cellv(baggage.tile_pos) == TILE_GOAL: 
      baggage.frame = BAGGAGE_ON_GOAL
    else:
      baggage.frame = BAGGAGE

# クリアチェック 
func is_clear() -> bool: 
  for baggage in baggage_layer.get_children():
    if baggage.frame == BAGGAGE:
      return false
  return true
