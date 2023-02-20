class_name Paddle
extends KinematicBody2D

# 定数
const X_SENSE = 4

# 変数
var sprite_size: Vector2 = get_node("Sprite").texture.get_size()
var dragging: bool = false
var prev_x: float
var dx: float = 0
var min_x: float
var max_x: float
onready var screen_size = get_viewport_rect().size

# 初期化処理
func _ready() -> void:
    # 左右移動の端
    min_x = sprite_size.x / 2
    max_x = screen_size.x - sprite_size.x / 2

# 入力検知
func _input(event) -> void:
    if event is InputEventMouseButton:
        if event.pressed:
            # ドラッグフラグ
            dragging = true
            prev_x = event.position.x
        else:
            dragging = false
    if event is InputEventMouseMotion:
        if dragging:
            # マウスx座標取得
            var pos_x: float = event.position.x
            # 前のx座標との差を元に移動量を算出
            dx = (pos_x - prev_x) * X_SENSE
            position.x += dx 
            # 画面からはみ出ないようにする
            position.x = clamp(position.x, min_x, max_x)
            # 前のx座標更新
            prev_x = pos_x
