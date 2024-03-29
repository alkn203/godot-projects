extends StaticBody2D

# 爆弾の威力
export (int) var power = 1
# タイルマップでの位置
var tile_pos = Vector2(0, 0)
# ノード
onready var main = get_node("/root/Main")

# Called when the node enters the scene tree for the first time.
func _ready():
  # 3秒後に爆発
  yield(get_tree().create_timer(3.0), "timeout")
  main.explode(self)
