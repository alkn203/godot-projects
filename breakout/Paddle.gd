extends KinematicBody2D

# 変数
var sprite_size: Vetor2 = get_node("Sprite").texture.get_size()
var dragging: bool = false
var prev_x: float
var dx: float = 0
var min_x: int
var max_x: int
onready var screen_size = get_viewport_rect().size

# 初期化処理
func _ready() -> void:
    # 前のx座標
    prev_ = position.x
    # 左右移動端
    min_x = sprite_size.x / 2
    max_x = screen_size.x - sprite_size.x / 2

# 入力検知
func _input(event):
    if event is InputEventMouseButton:
        if event.pressed:
            # ドラッグフラグ
            dragging = true
        else:
            dragging = false
    if event is InputEventMouseMotion:
        if dragging:
            # マウスx座標取得
            var pos_x: Vector2 = event.position.x
            # 前のx座標との差を元に移動量を算出
            dx = (pos_x - prev_x) * 10 
            # 画面からはみ出ないようにする
            position.x = clamp(pos.x, pos_min, pos_max)
