class_name Block
extends StaticBody2D

# 変数
var frame_index: int = 0

# 初期化処理
func _ready():
    get_node("Sprite").frame = frame_index
