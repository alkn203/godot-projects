extends KinematicBody2D

# 変数
var sprite_size: Vetor2 = get_node("Sprite").texture.get_size()
var dragging: bool = false
onready var screen_size = get_viewport_rect().size

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
            # マウス位置取得
            var pos: Vector2 = event.position
            # パドルの横座標を追従させ、画面からはみ出ないようにする
            var min_x: int = sprite_size.x / 2
            var max_x: int = screen_size.x - sprite_size.x / 2
            position.x = clamp(pos.x, pos_min, pos_max)
