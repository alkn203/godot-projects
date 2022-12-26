extends Node2D

# ノード
onready var player: Player = get_node("Player")
onready var camera: Camera2D = get_node("Camera2D")
onready var tilemap: TileMap = get_node("TileMap")

# 初期化処理
func _ready():
  # タイルマッブで配置されている矩形範囲
  var rect:Rect2 = tilemap.get_used_rect()
  #print(rect)
  # タイルマッブのセルサイズ
  var size:Vector2 = tilemap.get_cell_size()
  # カメラの左右移動範囲制限
  var limit_left = rect.position.x * size.x
  #print(limit_left)
  var limit_right = rect.end.x * size.x
  #print(limit_right)
  camera.limit_left = limit_left
  camera.limit_right = limit_right
  
# 毎フレーム処理
func _process(delta):
  # カメラをプレイヤーに追従させる
  camera.position.x = player.position.x
