# プレイヤークラス
class_name Player
extends Area2D

# シーン
const Shot = preload("res://scenes/Shot.tscn")

# 変数
var speed: int = 150
onready var screen_size: Vector2 = get_viewport_rect().size
onready var sprite_half: float = find_node("Sprite").texture.get_size().x / 2

# ノード
onready var shot_layer: CanvasLayer = get_node("/root/Main/ShotLayer")
onready var shot_timer: Timer = get_node("ShotTimer") 

# 毎フレーム処理
func _process(delta: float) ->  void:
    # 右移動
    if Input.is_action_pressed("ui_right"):
        position.x += speed * delta
    # 左移動
    if Input.is_action_pressed("ui_left"):
        position.x -= speed * delta
    # ショット発射
    if Input.is_action_just_pressed("space_key") and shot_timer.is_stopped():
        # ショット追加
        var shot = Shot.instance()
        shot.position = position
        shot_layer.add_child(shot)
        # ショット間隔管理タイマー開始
        shot_timer.start()
    # 移動を制限する
    position.x = clamp(position.x, sprite_half, screen_size.x - sprite_half)
