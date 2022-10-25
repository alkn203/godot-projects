extends KinematicBody2D

# 定数
# 重力
const GRAVITY = 9.8 / 2 
# ジャンプ力
const JUMP_POWER = 304

# 変数
# 移動方向ベクトル
var velocity = Vector2(0, 0)

# ノード
onready var animated_sprite = get_node("AnimatedSprite")

# 初期化処理
func _ready():
  # 最初のアニメーション
  animated_sprite.play("default")

# 毎フレーム処理
func _physics_process(delta):
  # 移動と当たり判定
  velocity = move_and_slide(velocity, Vector2(0, -1))
  # 床の上なら
  if is_on_floor():
    # アニメーション変更
    animated_sprite.play("default")
    # 左クリックでジャンプ
    if Input.is_action_just_pressed("ui_left_click"):
      velocity = Vector2(0, -JUMP_POWER)
      # アニメーション変更
      animated_sprite.play("jump")
  # 重力を加算
  velocity += Vector2(0, GRAVITY)
