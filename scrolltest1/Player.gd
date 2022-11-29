extends KinematicBody2D

# 定数
# 重力
const GRAVITY = 9.8 / 2 
# ジャンプ力
const JUMP_POWER = 304
# プレイヤーの速度
export (int) var speed = 150

# 変数
# 移動方向ベクトル
var velocity = Vector2.ZERO

# ノード
onready var animated_sprite = get_node("AnimatedSprite")

# 初期化処理
func _ready():
  # 最初のアニメーション
  animated_sprite.play("stop_left")
  
# 毎フレーム処理
func _physics_process(delta):
  # 左右キー移動
  if Input.is_action_pressed("ui_left"):
    velocity.x = -speed
    # アニメーション変更
    animated_sprite.play("walk_left")
  if Input.is_action_pressed("ui_right"):
    velocity.x = speed
    animated_sprite.play("walk_right")

  # 左右キーを離した時
  if Input.is_action_just_released("ui_left"):
    velocity.x = 0
    animated_sprite.play("stop_left")
  if Input.is_action_just_released("ui_right"):
    velocity.x = 0
    animated_sprite.play("stop_right")
  
  # 移動と当たり判定
  velocity = move_and_slide(velocity, Vector2(0, -1))
  
  # 床の上なら
  if is_on_floor():
    # 左クリックでジャンプ
    if Input.is_action_just_pressed("ui_jump"):
      velocity.y = -JUMP_POWER

  # 重力を加算
  velocity.y += GRAVITY
