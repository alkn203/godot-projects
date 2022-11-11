extends Node2D


# 定数
const TILE_SIZE = 64
const BAGGAGE_POS = [Vector2(4, 7), Vector2(4, 6)]

# ノード
onready var baggage_layer = get_node("BaggageLayer")

# シーン
onready var baggage_scene = preload("res://Baggage.tscn")


# 初期化処理
func _ready():
  # 荷物配置
  for pos in BAGGAGE_POS:
    var baggage = baggage_scene.instance()
    baggage.tile_pos = pos
    baggage.position = pos * TILE_SIZE
    baggage_layer.add_child(baggage)
